from langgraph.prebuilt.chat_agent_executor import AgentState

from app.api.v1.models.user_preferences import UserPreferences
# from app.services.agents.responses.financial_response import FinancialResponse
# from app.services.llm.output_parsers import TransactionAnalysisOutput


class FinancialState(AgentState):
    chat_thread_id: str
    user_id: str
    categories: list[str]
    user_preferences: UserPreferences
    text_extractions: list
    image_extractions: list
    audio_extractions: list
    # structured_response: FinancialResponse
    active_agent: str = "financial_expert"
