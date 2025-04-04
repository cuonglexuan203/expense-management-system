from fastapi import APIRouter, Depends

from app.core.security import get_api_key
from app.services.cache import cache_manager


router = APIRouter()


@router.get("/")
async def health_check(api_key: str = Depends(get_api_key)):
    """Health check endpoint that verifies the service is running."""
    # Check Redis connection
    redis = await cache_manager.get_redis()
    redis_status = await redis.ping()

    return {
        "status": "healthy",
        "service": "ai-microservice",
        "dependencies": {"redis": "connected" if redis_status else "disconnected"},
    }
