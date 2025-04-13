from langgraph.checkpoint.postgres.aio import AsyncPostgresSaver
from psycopg_pool import AsyncConnectionPool

from app.core.config import settings
from app.core.logging import get_logger


logger = get_logger(__name__)


class PostgresDb:
    def __init__(
        self, db_uri: str, max_pool_size: int = 20, connection_kwargs: dict = None
    ):
        self.db_uri = db_uri
        self.max_pool_size = max_pool_size
        self.connection_kwargs = connection_kwargs

        self.pool = AsyncConnectionPool(
            conninfo=self.db_uri,
            min_size=5,
            max_size=self.max_pool_size,
            kwargs=self.connection_kwargs,
            open=False,
        )

        self.checkpointer = None

    async def connect(self):
        await self.pool.open()
        await self.pool.wait()

        self.checkpointer = AsyncPostgresSaver(self.pool)

        await self.checkpointer.setup()
        logger.info("Database connection established and checkpointer initialized")

    async def disconnect(self):
        if self.pool:
            await self.pool.close()
            logger.info("Database connection pool closed")

    def get_checkpointer(self):
        if not self.checkpointer:
            raise RuntimeError("Database not initialized")

        return self.checkpointer

    def get_pool(self):
        if not self.pool:
            raise RuntimeError("Database not initialized")

        return self.pool


connection_kwargs = {
    "autocommit": True,
    "prepare_threshold": 0,
}

db = PostgresDb(
    settings.POSTGRES_URL,
    max_pool_size=settings.POSTGRES_MAX_POOL_SIZE,
    connection_kwargs=connection_kwargs,
)
