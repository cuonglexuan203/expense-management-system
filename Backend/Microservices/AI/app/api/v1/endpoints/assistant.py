from datetime import datetime, timezone
from fastapi import APIRouter, Depends
from app.api.v1.models.assistant_response import AssitantResponse
from app.api.v1.models.assistant_request import AssistantRequest
from app.core.logging import get_logger
from app.core.security import get_api_key
from app.services.graphs.ems_supervisor import ems_supervisor
from app.services.graphs.ems_swarm import ems_swarm
from langchain_core.messages import HumanMessage

logger = get_logger(__name__)

router = APIRouter()


@router.post("/supervisor")
async def supervisor(request: AssistantRequest, _: str = Depends(get_api_key)):

    graph = ems_supervisor.get_graph()

    messages = [
        HumanMessage(
            content=(
                # f"User ID: {request.user_id}\n"
                # f"User's preferences: {request.user_preferences}\n"
                # f"User's categories: {request.categories}\n"
                # f"Chat theard id: {request.chat_thread_id}\n"
                # f"Current time: {datetime.now(timezone.utc)}\n"
                # f"Time zone: {request.time_zone_id}\n"
                f"Query: {request.message}\n"
                f"File urls: {request.file_urls}"
            )
        ),
    ]

    result = await graph.ainvoke(
        {
            "messages": messages,
            "user_id": request.user_id,
            "categories": request.categories,
            "user_preferences": request.user_preferences,
            "text_extractions": None,
            "image_extractions": None,
            "audio_extractions": None,
        },
        config={
            "configurable": {
                "today": datetime.now(timezone.utc),
                "user_id": str(request.user_id),
                "wallet_id": str(request.wallet_id),
                "thread_id": str(request.chat_thread_id),
                "time_zone_id": request.time_zone_id,
                "categories": request.categories,
                "user_preferences": request.user_preferences,
            }
        },
    )

    if "messages" in result:
        for message in result["messages"][-6:]:
            message.pretty_print()

    return AssitantResponse.create_from_agent_response(result)


@router.post("/swarm")
async def swarm(request: AssistantRequest, _: str = Depends(get_api_key)):

    graph = ems_swarm.get_graph()

    messages = [
        HumanMessage(
            content=(
                # f"User ID: {request.user_id}\n"
                # f"User's preferences: {request.user_preferences}\n"
                # f"User's categories: {request.categories}\n"
                # f"Chat theard id: {request.chat_thread_id}\n"
                # f"Current time: {datetime.now(timezone.utc)}\n"
                # f"Time zone: {request.time_zone_id}\n"
                f"Query: {request.message}\n"
                f"File urls: {request.file_urls}"
            )
        ),
    ]

    result = await graph.ainvoke(
        {
            "messages": messages,
            "user_id": request.user_id,
            "categories": request.categories,
            "user_preferences": request.user_preferences,
            "text_extractions": None,
            "image_extractions": None,
            "audio_extractions": None,
        },
        config={
            "configurable": {
                "today": datetime.now(timezone.utc),
                "user_id": str(request.user_id),
                "wallet_id": str(request.wallet_id),
                "thread_id": str(request.chat_thread_id),
                "time_zone_id": request.time_zone_id,
                "categories": request.categories,
                "user_preferences": request.user_preferences,
            }
        },
    )

    if "messages" in result:
        for message in result["messages"][-4:]:
            message.pretty_print()

    return AssitantResponse.create_from_agent_response(result)
