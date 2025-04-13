from app.services.agents.base import BaseAgent
from langgraph.prebuilt import create_react_agent, ToolNode
# from app.services.agents.states.transaction_state import TransactionState
# from langgraph.checkpoint.memory import MemorySaver

EVENT_SYSTEM_PROMPT = """
You are a Event Scheduler to assist user about event-related actions. Always use one tool at a time
"""


class EventAgent(BaseAgent):
    name: str = "event_expert"

    def __init__(self, llm_config, tools=None):
        super().__init__(llm_config, tools)

    def _create_react_agent(self):
        """Create the React Agent for Event Scheduling."""

        tools = self.tools
        tool_node = ToolNode(tools) # noqa

        # checkpointer = MemorySaver()
        return create_react_agent(
            name=EventAgent.name,
            model=self.model,
            tools=tools,
            # state_schema=TransactionState,
            # checkpointer=checkpointer,
            prompt=EVENT_SYSTEM_PROMPT,
        )
