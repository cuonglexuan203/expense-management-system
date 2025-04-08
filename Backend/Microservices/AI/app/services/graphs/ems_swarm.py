from langgraph.checkpoint.memory import InMemorySaver
from app.schemas.llm_config import LLMConfig
from app.services.agents.event_agent import EventAgent
from app.services.agents.states.transaction_state import TransactionState
from app.services.agents.tools.transaction import extract_from_text, extract_from_image, extract_from_audio
from app.services.agents.transaction_agent import TransactionAgent
from app.services.llm.enums import LLMModel, LLMProvider
from langgraph_swarm import create_handoff_tool, create_swarm


financial_agent = TransactionAgent(
    llm_config=LLMConfig(
        provider=LLMProvider.OPENAI,
        model=LLMModel.GPT_4O_MINI,
        temperature=0,
    ),
    tools=[extract_from_text, extract_from_image, extract_from_audio, create_handoff_tool(agent_name="event_expert")],
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
            description="Transfer to financial_expert, they can help with transaction-related problems",
        ),
    ],
).get_agent()

agents = [financial_agent, event_agent]

workflow = create_swarm(
    agents=agents,
    state_schema=TransactionState,
    default_active_agent="financial_expert",
)

checkpointer = InMemorySaver()

ems_swarm = workflow.compile(
    name="EMS Swarm Workflow",
    checkpointer=checkpointer,
)
