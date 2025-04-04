from contextlib import asynccontextmanager
from fastapi import FastAPI
from loguru import logger
from app.core import settings
from app.core.logging import configure_logging
from app.services.cache import cache_manager


@asynccontextmanager
async def lifespan(app: FastAPI):
    """
    FastAPI lifespan handler
    """
    configure_logging()
    logger.info(f"Starting {settings.PROJECT_NAME} v{settings.VERSION}")

    yield

    logger.info(f"Shutting down {settings.PROJECT_NAME}")
    await cache_manager.close()
