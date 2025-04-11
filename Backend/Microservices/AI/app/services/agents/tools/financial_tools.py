from typing import Annotated
from langgraph.prebuilt import InjectedState
from langchain_core.tools import tool
from app.api.v1.models.transaction_response import TransactionResponse
from app.schemas.llm_config import LLMConfig
from app.services.backend import backend_client
from app.services.extractors.audio_extractor import AudioExtractor
from app.services.extractors.image_extractor import ImageExtractor
from app.services.extractors.text_extractor import TextExtractor
from app.services.llm.enums import LLMModel, LLMProvider


@tool
async def extract_from_text(
    query: Annotated[str, "Query to extract transactions"],
    state: Annotated[dict, InjectedState],
):
    """Extract transactions from text only message"""
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


@tool
async def extract_from_image(
    # query: Annotated[str, "Query to extract transactions"],
    image_urls: Annotated[list[str], "Image urls to extract transactions"],
    state: Annotated[dict, InjectedState],
):
    """Extract transactions from image messages"""
    extractor = ImageExtractor(
        LLMConfig(
            provider=LLMProvider.GOOGLE,
            model=LLMModel.GEMINI_20_FLASH,
            temperature=0,
        )
    )
    result = await extractor.extract(
        state["user_id"],
        {
            # "message": query,
            "categories": state["categories"],
            "user_preferences": state["user_preferences"],
            "image_urls": image_urls,
        },
    )

    return TransactionResponse(
        transactions=result.transactions,
        introduction=result.introduction,
        message="Successfully extracted transactions from image",
    )


@tool
async def extract_from_audio(
    # query: Annotated[str, "Query to extract transactions"],
    audio_urls: Annotated[list[str], "Audio urls to extract transactions"],
    state: Annotated[dict, InjectedState],
):
    """Extract transactions from audio messages"""
    extractor = AudioExtractor(
        LLMConfig(
            provider=LLMProvider.OPENAI,
            model=LLMModel.GPT_4O_MINI_AUDIO_PREVIEW,
            temperature=0,
        )
    )
    result = await extractor.extract(
        state["user_id"],
        {
            # "message": query,
            "categories": state["categories"],
            "user_preferences": state["user_preferences"],
            "audio_urls": audio_urls,
        },
    )

    return TransactionResponse(
        transactions=result.transactions,
        introduction=result.introduction,
        message="Successfully extracted transactions from audio",
    )


@tool
async def get_transactions(user_id: Annotated[str, "user id"]):
    """Get user's transaction history"""
    return await backend_client.get_transactions(user_id)


@tool
async def get_messages(
    user_id: Annotated[str, "user id"], chat_thread_id: Annotated[int, "chat thread id"]
):
    """ Get messages of a chat thread of user """
    return await backend_client.get_messages(user_id, chat_thread_id)


@tool
async def get_wallets(user_id: Annotated[str, "user id"]):
    """Get wallets of user"""
    return await backend_client.get_wallets(user_id)


@tool
async def get_wallet_by_id(
    user_id: Annotated[str, "user id"], wallet_id: Annotated[str, "wallet id"]
):
    """Get a wallet of user"""
    return await backend_client.get_wallet_by_id(user_id, wallet_id)
