from langgraph_supervisor import create_supervisor
from langgraph.checkpoint.memory import InMemorySaver
from app.schemas.llm_config import LLMConfig
from app.services.agents.event_agent import EventAgent
from app.services.agents.states.transaction_state import TransactionState
from app.services.agents.tools.transaction import extract_from_text
from app.services.agents.transaction_agent import TransactionAgent
from app.services.llm.enums import LLMModel, LLMProvider
from app.services.llm.factory import LLMFactory


PROMPT = (
    "You are a team supervisor managing a expert transaction extractor and a expert event scheduler"
    "For financial problems, use transaction_agent"
    "For event problems, use event_agent"
)

transaction_agent = TransactionAgent(
    llm_config=LLMConfig(
        provider=LLMProvider.GOOGLE,
        model=LLMModel.GEMINI_20_FLASH,
        temperature=0,
    ),
    tools=[extract_from_text],
).get_agent()

event_agent = EventAgent(
    llm_config=LLMConfig(
        provider=LLMProvider.OPENAI,
        model=LLMModel.GPT_4O_MINI,
        temperature=0,
    ),
    tools=[extract_from_text],
).get_agent()

agents = [transaction_agent, event_agent]

model = LLMFactory.create(
    LLMConfig(
        provider=LLMProvider.OPENAI,
        model=LLMModel.GPT_4O_MINI,
        temperature=0,
    )
)


ems_supervisor = create_supervisor(
    agents=agents, state_schema=TransactionState, model=model, prompt=PROMPT
)

checkpointer = InMemorySaver()

ems_workflow = ems_supervisor.compile(
    name="Expense management system supervisor",
    checkpointer=checkpointer,
    # output_mode="last_message",
)
