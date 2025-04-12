from typing import Annotated
from langgraph.prebuilt import InjectedState
from langchain_core.tools import tool
from app.schemas.llm_config import LLMConfig
from app.services.backend import backend_client
from app.services.extractors.audio_extractor import AudioExtractor
from app.services.extractors.image_extractor import ImageExtractor
from app.services.extractors.text_extractor import TextExtractor
from app.services.llm.enums import LLMModel, LLMProvider
from langgraph.types import Command
from langchain_core.tools.base import InjectedToolCallId
from langchain_core.messages import ToolMessage


@tool
async def extract_from_text(
    query: Annotated[str, "Query to extract transactions"],
    state: Annotated[dict, InjectedState],
    tool_call_id: Annotated[str, InjectedToolCallId],
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

    return Command(
        update={
            "messages": [ToolMessage(content=result, tool_call_id=tool_call_id)],
            "text_extractions": result.transactions,
        }
    )


@tool
async def extract_from_image(
    # query: Annotated[str, "Query to extract transactions"],
    image_urls: Annotated[list[str], "Image urls to extract transactions"],
    state: Annotated[dict, InjectedState],
    tool_call_id: Annotated[str, InjectedToolCallId],
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

    return Command(
        update={
            "messages": [ToolMessage(result, tool_call_id=tool_call_id)],
            "image_extractions": result.transactions,
        }
    )


@tool
async def extract_from_audio(
    # query: Annotated[str, "Query to extract transactions"],
    audio_urls: Annotated[list[str], "Audio urls to extract transactions"],
    state: Annotated[dict, InjectedState],
    tool_call_id: Annotated[str, InjectedToolCallId],
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

    return Command(
        update={
            "messages": [ToolMessage(result, tool_call_id=tool_call_id)],
            "audio_extractions": result.transactions,
        }
    )


@tool
async def get_transactions(user_id: Annotated[str, "user id"]):
    """Get user's transaction history"""
    return await backend_client.get_transactions(user_id)


@tool
async def get_messages(
    user_id: Annotated[str, "user id"],
    chat_thread_id: Annotated[int, "chat thread id"],
    message_role: Annotated[
        str | None, "message role ('User' or 'System') to filter by"
    ] = None,
    content: Annotated[str | None, "content to filter by"] = None,
):
    """Get messages of a chat thread of user and/or system

    Args:
        message_role: optional, please use 'User' or 'System' to filter, if need
        content: options, please use this to filter, if need
    """
    return await backend_client.get_messages(
        user_id, chat_thread_id, params={"role": message_role, "content": content}
    )


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
