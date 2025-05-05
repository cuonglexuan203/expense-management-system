from app.schemas.llm_config import LLMConfig
from app.services.agents.event_agent import EventAgent
from app.services.agents.states.state import FinancialState
from app.services.agents.tools.financial_tools import (
    extract_from_text,
    extract_from_image,
    extract_from_audio,
    get_transactions,
    get_messages,
    get_wallets,
    get_wallet_by_id,
    # update_extracted_transactions_status,
)
from app.services.agents.tools.event_tools import (
    schedule_event,
    get_event_occurrences,
)
from app.services.agents.financial_agent import FinancialAgent
from app.services.llm.enums import LLMModel, LLMProvider
from langgraph_swarm import create_handoff_tool, create_swarm
from langgraph.graph.state import CompiledStateGraph
from app.services.memories.postgres_db import db


class EMSSwarm:
    """Expense management system swarm architecture"""

    name: str = "ems_swarm"

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
                get_transactions,
                get_messages,
                get_wallets,
                get_wallet_by_id,
                # update_extracted_transactions_status,
                create_handoff_tool(
                    agent_name=EventAgent.name,
                    description=f"Transfer to {EventAgent.name}, they can help with event-related problems (event scheduling feature)",),
            ],
        ).get_agent()

        event_agent = EventAgent(
            llm_config=LLMConfig(
                provider=LLMProvider.OPENAI,
                model=LLMModel.GPT_4O_MINI,
                temperature=0,
            ),
            tools=[
                schedule_event,
                get_event_occurrences,
                create_handoff_tool(
                    agent_name=FinancialAgent.name,
                    description=f"Transfer to {FinancialAgent.name}, they can help with financial-related problems",
                ),
            ],
        ).get_agent()

        self.agents = [financial_agent, event_agent]

        self.workflow = create_swarm(
            agents=self.agents,
            state_schema=FinancialState,
            default_active_agent=FinancialAgent.name,
        )

        self.checkpointer = None

        self.swarm = None
        self._initialized = False

    async def initialize(self):
        """Initialize the swarm with checkpointer from db"""
        if not self._initialized:
            # Get the checkpointer from the database
            checkpointer = db.get_checkpointer()

            # Compile the workflow
            self.swarm = self.workflow.compile(
                name=EMSSwarm.name,
                checkpointer=checkpointer,
            )
            self._initialized = True

        return self

    def get_graph(self) -> CompiledStateGraph:
        if not self._initialized:
            raise RuntimeError("EMSSwarm not initialized, call initialize() first")

        return self.swarm


ems_swarm = EMSSwarm()
