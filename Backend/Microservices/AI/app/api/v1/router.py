from fastapi import APIRouter
from app.api.v1.endpoints import developer, extraction, health

api_router = APIRouter()


api_router.include_router(
    extraction.router,
    prefix="/extractions",
    tags=["Transaction Extraction"],
)

api_router.include_router(health.router, prefix="/health", tags=["Health"])

api_router.include_router(developer.router, prefix="/developer", tags=["Developer"])
