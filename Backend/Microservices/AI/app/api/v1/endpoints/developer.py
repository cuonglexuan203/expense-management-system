from fastapi import APIRouter

from app.core.logging import get_logger


router = APIRouter()

logger = get_logger(__name__)


@router.get("ping")
def Ping():
    return {"message": "Pong"}
