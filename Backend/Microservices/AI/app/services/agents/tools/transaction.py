from typing import Annotated
from langgraph.prebuilt import InjectedState
from langchain_core.tools import tool
from app.api.v1.models.transaction_response import TransactionResponse
from app.schemas.llm_config import LLMConfig
from app.services.extractors.text_extractor import TextExtractor
from app.services.llm.enums import LLMModel, LLMProvider


@tool
async def extract_from_text(
    query: Annotated[str, "User message to extract transactions"],
    state: Annotated[dict, InjectedState],
):
    """Extract transactions from text message."""
    extractor = TextExtractor(
        LLMConfig(
            provider=LLMProvider.GOOGLE,
            model=LLMModel.GEMINI_20_FLASH,
            temperature=0,
        )
    )
    result = await extractor.extract(
        state["user_id"],
        {
            "message": query,
            "categories": state["categories"],
            "user_preferences": state["user_preferences"],
        },
    )

    return TransactionResponse(
        transactions=result.transactions,
        introduction=result.introduction,
        message="Successfully extracted transactions from text",
    )
