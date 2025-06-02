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

        financial_to_event_handoff_desc = (
            f"Handoff to the {EventAgent.name} to manage tasks involving scheduling events "
            f"(e.g., 'schedule a meeting for my kid's school fee', 'birthday dinner reminder'), setting up reminders, "
            f"or creating/managing recurring or periodic expenses and income "
            f"(e.g., 'set up monthly rent payment', 'add weekly allowance', 'yearly Netflix subscription'). "
            f"Use this when the user's primary intent is to create, modify, or inquire about a scheduled or recurring item."
        )

        # Optimized description for EventAgent to handoff to FinancialAgent
        event_to_financial_handoff_desc = (
            f"Handoff to the {FinancialAgent.name} for all other financial management tasks. "
            f"This includes adding individual, non-recurring expense/income transactions (from text, image, or audio) (e.g., 'Breakfast 10 dollar', 'Bread 2 dollar') "
            f"requesting financial history or summaries, seeking financial advice or analysis, "
            f"setting or tracking financial goals (e.g., 'how am I doing on my car savings goal?'), "
            f"or asking general questions about their finances. "
            f"Use this if the user's request is NOT primarily about scheduling or managing recurring/periodic items."
        )

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
                    description=financial_to_event_handoff_desc,
                ),
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
                    description=event_to_financial_handoff_desc,
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
