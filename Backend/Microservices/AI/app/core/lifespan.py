from contextlib import asynccontextmanager
from fastapi import FastAPI
from loguru import logger
from app.core import settings
from app.core.logging import configure_logging
from app.services.cache import cache_manager
from app.services.memories.postgres_db import db
from app.services.graphs.ems_swarm import ems_swarm


@asynccontextmanager
async def lifespan(app: FastAPI):
    """
    FastAPI lifespan handler
    """
    configure_logging()
    logger.info(f"Starting {settings.PROJECT_NAME} v{settings.VERSION}")

    await db.connect()
    await ems_swarm.initialize()

    yield

    logger.info(f"Shutting down {settings.PROJECT_NAME}")
    await db.disconnect()
    await cache_manager.close()
