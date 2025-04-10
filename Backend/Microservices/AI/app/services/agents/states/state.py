from langgraph.prebuilt.chat_agent_executor import AgentState

from app.api.v1.models.transaction_response import TransactionResponse
from app.api.v1.models.user_preferences import UserPreferences


class AppState(AgentState):
    user_id: str
    categories: list[str]
    user_preferences: UserPreferences
    structured_response: TransactionResponse
    active_agent: str = "financial_expert"
