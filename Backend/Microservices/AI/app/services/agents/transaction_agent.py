from app.api.v1.models.transaction_response import TransactionResponse
from app.services.agents.base import BaseAgent
from langgraph.prebuilt import create_react_agent, ToolNode
from app.services.agents.states.transaction_state import TransactionState
from langgraph.checkpoint.memory import MemorySaver

TRANSACTION_SYSTEM_PROMPT = """
You are a Transaction Extractor to extract transactions from user message (any combination of: text, image, audio). Always use one tool at a time
"""


class TransactionAgent(BaseAgent):
    def __init__(self, llm_config, tools=None):
        super().__init__(llm_config, tools)

    def _create_react_agent(self):
        """Create the React Agent for transaction extraction."""

        tools = self.tools
        tool_node = ToolNode(tools)

        checkpointer = MemorySaver()
        return create_react_agent(
            name="transaction_expert",
            model=self.model,
            tools=tools,
            state_schema=TransactionState,
            checkpointer=checkpointer,
            prompt=TRANSACTION_SYSTEM_PROMPT,
            # response_format=TransactionResponse
        )
