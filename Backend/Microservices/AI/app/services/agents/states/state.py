import operator
from typing import Annotated
from langgraph.prebuilt.chat_agent_executor import AgentState

from app.api.v1.models.user_preferences import UserPreferences
# from app.services.agents.responses.financial_response import FinancialResponse
# from app.services.llm.output_parsers import TransactionAnalysisOutput


class AppState(AgentState):
    chat_thread_id: str
    user_id: str
    categories: list[str]
    user_preferences: UserPreferences
    extraction_results: Annotated[list, operator.add]
    # structured_response: FinancialResponse
    active_agent: str = "financial_expert"
