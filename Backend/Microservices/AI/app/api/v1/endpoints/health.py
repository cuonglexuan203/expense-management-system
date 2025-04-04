from fastapi import APIRouter, Depends

from app.core.logging import get_logger
from app.core.security import get_api_key
from app.services.cache import cache_manager

logger = get_logger(__name__)

router = APIRouter()


@router.get("/health")
async def health_check(api_key: str = Depends(get_api_key)):
    """Health check endpoint that verifies the service is running."""
    status = "healthy"
    dependencies = {}

    try:
        # Check Redis connection
        redis = await cache_manager.get_redis()
        redis_status = await redis.ping()
        dependencies["redis"] = "connected" if redis_status else "disconnected"

        if not redis_status:
            status = "degraded"
    except Exception as e:
        logger.error(f"Error in checking redis health: {e}")
        dependencies["redis"] = "disconnected"
        status = "unhealthy"

    return {
        "status": status,
        "service": "ai-microservice",
        "dependencies": dependencies,
    }
