import datetime
from fastapi import APIRouter, Depends
from app.api.v1.models.assistant_response import AssitantResponse
from app.api.v1.models.assistant_request import AssistantRequest
from app.core.logging import get_logger
from app.core.security import get_api_key
from app.services.graphs.ems_supervisor import EMSSupervisor
from app.services.graphs.ems_supervisor import PROMPT2
from app.services.graphs.ems_swarm import ems_swarm
from langchain_core.messages import HumanMessage

logger = get_logger(__name__)

router = APIRouter()


@router.post("/supervisor")
async def supervisor(request: AssistantRequest, _: str = Depends(get_api_key)):

    prompt = PROMPT2.format(
        categories=", ".join(request.categories),
        user_preferences=request.user_preferences,
        currency_code=request.user_preferences.currency_code,
        language=request.user_preferences.language or "English",
    )

    graph = EMSSupervisor(prompt).get_graph()

    result = await graph.ainvoke(
        {
            "messages": [
                {
                    "role": "user",
                    "content": request.message + f"\n\n {request.file_urls}",
                }
            ],
            "user_id": request.user_id,
            "categories": ", ".join(request.categories),
            "user_preferences": request.user_preferences,
            "currency_code": request.user_preferences.currency_code,
            "language": request.user_preferences.language or "English",
        },
        config={"configurable": {"thread_id": "1"}},
        interrupt_after=["financial_expert"],
    )

    if "messages" in result:
        for message in result["messages"]:
            message.pretty_print()

    return result


@router.post("/swarm")
async def swarm(request: AssistantRequest, _: str = Depends(get_api_key)):

    graph = ems_swarm.get_graph()

    messages = [
        HumanMessage(content=(
                f"User ID: {request.user_id}\n"
                f"User's preferences: {request.user_preferences}\n"
                f"User's categories: {request.categories}\n"
                f"Chat theard id: {request.chat_thread_id}\n"
                f"Current time: {datetime.datetime.now(datetime.timezone.utc)}\n"
                f"Query: {request.message}\n"
                f"File urls: {request.file_urls}"
            )),
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
        config={"configurable": {"thread_id": str(request.chat_thread_id)}},
    )

    if "messages" in result:
        for message in result["messages"]:
            message.pretty_print()

    return AssitantResponse.create_from_agent_response(result)
