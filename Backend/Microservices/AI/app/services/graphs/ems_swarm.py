from langgraph.checkpoint.memory import InMemorySaver
from app.schemas.llm_config import LLMConfig
from app.services.agents.event_agent import EventAgent
from app.services.agents.states.state import AppState
from app.services.agents.tools.financial_tools import (
    extract_from_text,
    extract_from_image,
    extract_from_audio,
)
from app.services.agents.financial_agent import FinancialAgent
from app.services.llm.enums import LLMModel, LLMProvider
from langgraph_swarm import create_handoff_tool, create_swarm
from langgraph.graph.state import CompiledStateGraph


class EMSSwarm:
    """Expense management system swarm architecture"""

    def __init__(self):
        financial_agent = FinancialAgent(
            llm_config=LLMConfig(
                provider=LLMProvider.OPENAI,
                model=LLMModel.GPT_4O_MINI,
                temperature=0,
            ),
            tools=[
                extract_from_text,
                extract_from_image,
                extract_from_audio,
                create_handoff_tool(agent_name="event_expert"),
            ],
        ).get_agent()

        event_agent = EventAgent(
            llm_config=LLMConfig(
                provider=LLMProvider.OPENAI,
                model=LLMModel.GPT_4O_MINI,
                temperature=0,
            ),
            tools=[
                extract_from_text,
                create_handoff_tool(
                    agent_name="financial_expert",
                    description="Transfer to financial_expert, they can help with financial-related problems",
                ),
            ],
        ).get_agent()

        self.agents = [financial_agent, event_agent]

        self.workflow = create_swarm(
            agents=self.agents,
            state_schema=AppState,
            default_active_agent="financial_expert",
        )

        self.checkpointer = InMemorySaver()

        self.swarm = self.workflow.compile(
            name="ems_swarm",
            checkpointer=self.checkpointer,
        )

    def get_graph(self) -> CompiledStateGraph:
        return self.swarm
