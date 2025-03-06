from fastapi import FastAPI
from app.core.config import settings
from app.core.logging import get_logger, configure_logging


logger = get_logger(__name__)


def startup_event_handler(app: FastAPI) -> callable:
    """
    FastAPI startup event handler
    """

    async def startup() -> None:
        # Configure logging
        configure_logging()

        logger.info(f"Starting {settings.PROJECT_NAME} v{settings.VERSION}")

    return startup


def shutdown_event_handler(app: FastAPI) -> callable:
    """
    FastAPI shutdown event handler
    """

    async def shutdown() -> None:
        logger.info(f"Shutting down {settings.PROJECT_NAME}")

    return shutdown
