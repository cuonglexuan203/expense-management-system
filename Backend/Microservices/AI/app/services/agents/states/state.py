from langgraph.prebuilt.chat_agent_executor import AgentState

from app.api.v1.models.user_preferences import UserPreferences
from app.services.agents.responses.financial_response import FinancialResponse


class AppState(AgentState):
    user_id: str
    categories: list[str]
    user_preferences: UserPreferences
    structured_response: FinancialResponse
    active_agent: str = "financial_expert"
