from fastapi import APIRouter
from app.api.v1.endpoints import extractions

api_router = APIRouter()


api_router.include_router(
    extractions.router,
    prefix="/extractions",
    tags=["Transaction Extraction"],
)
