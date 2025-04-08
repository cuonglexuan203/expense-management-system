from pydantic import BaseModel

# from app.api.v1.models.transaction_response import TransactionResponse
from app.services.agents.base import BaseAgent
from langgraph.prebuilt import create_react_agent, ToolNode
from app.services.agents.states.transaction_state import TransactionState
from langgraph.checkpoint.memory import MemorySaver

TRANSACTION_SYSTEM_PROMPT = (
    "You are a financial expert. You can extract transactions from user message (any combination of: text, image, audio)."
    # "Always use one tool at a time and you just return the intact tool's result as it is"
    # "*Note: YOU JUST RETURN THE TOOL RESULT. DO NOT MAKE ANY CHANGE!"
)


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
        tool_node = ToolNode(tools)  # noqa

        checkpointer = MemorySaver()
        return create_react_agent(
            name="financial_expert",
            model=self.model,
            tools=tools,
            state_schema=TransactionState,
            checkpointer=checkpointer,
            prompt=TRANSACTION_SYSTEM_PROMPT,
            response_format=TransactionResponse,
        )
