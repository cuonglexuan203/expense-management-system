from fastapi import APIRouter
from api.v1.endpoints import analyzing_agent

api_router = APIRouter()


api_router.include_router(
    analyzing_agent.router,
    prefix="/analyzing-agent",
    tags=["agent"],
)
