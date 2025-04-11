from pydantic import BaseModel

# from app.api.v1.models.transaction_response import TransactionResponse
from app.services.agents.base import BaseAgent
from langgraph.prebuilt import create_react_agent, ToolNode
from app.services.agents.states.state import AppState
from langgraph.checkpoint.memory import MemorySaver

FINANCIAL_SYSTEM_PROMPT = """
You are a specialized financial assistant. Your goal is to help the user manage their expenses and finances effectively.
Use the available tools to answer questions, retrieve data, and perform actions related to finance.

--- Your Skills ---
- Extract transactions from user message (any combination of: text, image, audio)

--- Important Instructions ---
1. ALWAYS use the user's preferred language and currency, derived from their preferences if available (default: en, USD).
2. When extracting transactions, suggest categories ONLY from the user's custom categories if available.
   If no categories are set up or none match, suggest a sensible default or leave it blank.
3. Be clear, concise, and helpful.
"""


class Transaction(BaseModel):
    name: str = None
    category: str = None
    type: str = None
    amount: float = None
    currency: str = None
    occurred_at: str = None


class TransactionResponse(BaseModel):
    """Response model for transaction extraction endpoints."""

    transactions: list[Transaction]
    introduction: str
    message: str


class FinancialAgent(BaseAgent):
    def __init__(self, llm_config, tools=None):
        super().__init__(llm_config, tools)

    def _create_react_agent(self):
        """Create the React Agent for transaction extraction."""

        tools = self.tools
        # Injecting state into tools
        tool_node = ToolNode(tools)  # noqa

        checkpointer = MemorySaver()
        return create_react_agent(
            name="financial_expert",
            model=self.model,
            tools=tools,
            state_schema=AppState,
            checkpointer=checkpointer,
            prompt=FINANCIAL_SYSTEM_PROMPT,
            response_format=TransactionResponse,
        )
