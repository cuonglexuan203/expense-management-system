from fastapi import APIRouter
from app.api.v1.endpoints import analyze_transaction

api_router = APIRouter()


api_router.include_router(
    analyze_transaction.router,
    prefix="/analyze-transaction",
    tags=["agent"],
)
