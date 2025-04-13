from typing import Annotated, Literal, Optional
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
    """
    Extract transactions from user messages
    Args:
        query: the user message may contain one or multiple transactions which need to extract
    """
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
    user_id: Annotated[str, "User's unique identifier"],
    chat_thread_id: Annotated[int, "Unique ID of the chat conversation"],
    message_role: Annotated[
        Optional[Literal["Human", "System"]],
        "Filter by message sender: 'Human' for user messages, 'System' for AI responses",
    ] = None,
    content_contains: Annotated[
        Optional[str],
        "Filter messages containing this text (e.g., 'budget' to find budget-related messages)",
    ] = None,
    page_size: Annotated[
        Optional[int], "Number of messages to return (default: 5, max: 100)"
    ] = 5,
    page_number: Annotated[
        Optional[int], "Page number for pagination, starts at 1 (default: 1)"
    ] = 1,
    sort: Annotated[
        Optional[Literal["DESC", "ASC"]],
        "sort order, default descending by message created time"
    ] = "DESC"
):
    """Retrieves messages from a specific chat conversation thread.

    Common use cases:
    - Get recent messages: Only provide user_id and chat_thread_id
    - Find user questions about a topic: Set message_role="Human" and content_contains="topic"
    - Find system responses about a topic: Set message_role="System" and content_contains="topic"
    - Get more message history: Increase page_number to see older messages

    Args:
        user_id: The user's ID (required)
        chat_thread_id: The conversation thread ID (required)
        message_role: Filter by who sent the message - either "Human" or "System" (optional), if empty, get both message types
        content_contains: Filter messages containing this text (optional)
        page_size: Number of messages per page (optional, default: 5)
        page_number: Page number, higher numbers return older messages (optional, default: 1)
        sort: sort order (optional, default: descending from newest to oldest)

    **Note**: A message can have multiple extracted transactions

    Returns:
        List of messages along with its extracted transactions
    """
    return await backend_client.get_messages(
        user_id,
        chat_thread_id,
        params={
            "role": message_role,
            "content": content_contains,
            "pageSize": page_size,
            "pageNumber": page_number,
        },
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


@tool
async def update_extracted_transactions_status(
    user_id: Annotated[str, "User's unique identifier"],
    wallet_id: Annotated[int, "ID of the wallet containing the transactions"],
    message_id: Annotated[
        int, "ID of the message where extracted transactions were associated with"
    ],
    confirmation_status: Annotated[
        Literal["Confirmed", "Rejected"],
        "Either 'Confirmed' (to accept transactions) or 'Rejected' (to decline)",
    ],
):
    """Update the confirmation status of previously extracted financial transactions.

    This tool should be used after transactions have been extracted from user messages (text/images/audio)
    and the user has reviewed them. It marks all transactions from a specific message as either confirmed
    (approved by user) or rejected (declined by user).

    Example scenarios:
    - When user says "Yes, those transactions look correct" → use "Confirmed"
    - When user says "No, those aren't right" → use "Rejected"
    - When user approves some specific transactions → use separate tool for partial confirmation

    Args:
        user_id: The user's unique identifier
        wallet_id: The wallet where transactions belong
        message_id: The message ID containing the extracted transactions, you could get it from a tool to get messages
        confirmation_status: Either "Confirmed" or "Rejected"

    **Note**: message_id must be the system message (role: System) because after Backend extracted transactions, \
extracted transactions will be stored along with the system message which will response to user

    Returns:
        List of processed transactions
    """
    return await backend_client.update_extracted_transactions_status(
        user_id, wallet_id, message_id, confirmation_status
    )
