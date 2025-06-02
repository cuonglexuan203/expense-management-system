import asyncio
import psycopg  # For psycopg specific exceptions
from psycopg_pool import AsyncConnectionPool
from langgraph.checkpoint.postgres.aio import AsyncPostgresSaver  # [[1]], [[6]]

from app.core.config import settings  # Assuming settings might include retry configs
from app.core.logging import get_logger

logger = get_logger(__name__)


class PostgresDb:
    def __init__(
        self,
        db_uri: str,
        max_pool_size: int = 20,
        min_pool_size: int = 5,  # It's good practice to define min_size
        connection_kwargs: dict = None,
        max_connect_retries: int = 3,  # Number of retries
        connect_retry_delay: float = 5.0,  # Delay between retries in seconds
    ):
        self.db_uri = db_uri
        self.max_pool_size = max_pool_size
        self.min_pool_size = min_pool_size
        self.connection_kwargs = (
            connection_kwargs if connection_kwargs is not None else {}
        )
        self.max_connect_retries = max_connect_retries
        self.connect_retry_delay = connect_retry_delay

        # Initialize pool and checkpointer to None. They will be set in connect().
        self.pool: AsyncConnectionPool | None = None
        self.checkpointer: AsyncPostgresSaver | None = None

    async def connect(self):
        if self.pool and not self.pool.closed:
            # If checkpointer is somehow not set but pool is, re-initialize
            if not self.checkpointer:
                logger.warning(
                    "Connection pool was open, but checkpointer not initialized. Re-initializing checkpointer."
                )
                try:
                    self.checkpointer = AsyncPostgresSaver(self.pool)  # [[3]]
                    await self.checkpointer.setup()  # [[4]]
                    logger.info("Checkpointer re-initialized successfully.")
                except Exception as e:
                    logger.error(f"Failed to re-initialize checkpointer: {e}")
                    # Decide if you want to close the pool and try a full reconnect or raise
                    await self.disconnect()  # Attempt to clean up
                    raise RuntimeError(
                        f"Failed to re-initialize checkpointer after pool was found open: {e}"
                    ) from e
            else:
                logger.info(
                    "Database connection pool already open and checkpointer initialized."
                )
            return

        # Attempt to connect with retries
        for attempt in range(self.max_connect_retries + 1):
            try:
                logger.info(
                    f"Attempting to connect to PostgreSQL (attempt {attempt + 1}/{self.max_connect_retries + 1})..."
                )
                self.pool = AsyncConnectionPool(
                    conninfo=self.db_uri,
                    min_size=self.min_pool_size,
                    max_size=self.max_pool_size,
                    kwargs=self.connection_kwargs,
                    # `open` is called explicitly below, so not passing `open=True` here.
                    # You can also add timeouts like `open_timeout` or `connect_timeout` in kwargs if needed.
                )

                # Explicitly open the pool and wait for connections to be established
                await self.pool.open(
                    wait=True
                )  # `wait=True` waits for `min_size` connections

                logger.info("Connection pool opened successfully.")

                # Initialize and setup the checkpointer
                self.checkpointer = AsyncPostgresSaver(self.pool)  # [[1]], [[3]]
                await self.checkpointer.setup()  # [[4]]
                logger.info(
                    "Database connection established and checkpointer initialized."
                )
                return  # Success

            except psycopg.OperationalError as e:
                logger.error(
                    f"OperationalError on database connection attempt {attempt + 1}: {e}"
                )
                # Specific check for "too many connections" or similar "full" scenarios
                # Note: The exact error message might vary depending on PostgreSQL version and configuration.
                # You might need to adjust the string checks.
                err_msg_lower = str(e).lower()
                if (
                    "too many clients" in err_msg_lower
                    or "remaining connection slots are reserved" in err_msg_lower
                    or "connection limit" in err_msg_lower
                ):
                    logger.warning(
                        "Database connection limit likely reached. This might be the 'full' state."
                    )

                if attempt < self.max_connect_retries:
                    logger.info(
                        f"Retrying connection in {self.connect_retry_delay} seconds..."
                    )
                    await asyncio.sleep(self.connect_retry_delay)
                else:
                    logger.error(
                        "Max connection retries reached. Failed to connect to the database."
                    )
                    if (
                        self.pool and not self.pool.closed
                    ):  # Attempt to close if partially opened
                        await self.pool.close()
                    self.pool = None  # Ensure pool is None if connection failed
                    self.checkpointer = None
                    raise  # Re-raise the last caught OperationalError

            except (
                Exception
            ) as e:  # Catch other unexpected errors during connection or setup
                logger.error(
                    f"An unexpected error occurred during database connection or checkpointer setup (attempt {attempt + 1}): {e}"
                )
                if attempt < self.max_connect_retries:
                    logger.info(
                        f"Retrying connection in {self.connect_retry_delay} seconds..."
                    )
                    await asyncio.sleep(self.connect_retry_delay)
                else:
                    logger.error(
                        "Max connection retries reached due to an unexpected error."
                    )
                    if self.pool and not self.pool.closed:
                        await self.pool.close()
                    self.pool = None
                    self.checkpointer = None
                    raise  # Re-raise the last caught unexpected exception

        # Fallback, though the loop should either return or raise.
        if not self.checkpointer:
            raise RuntimeError(
                "Failed to connect to database and initialize checkpointer after all retries."
            )

    async def disconnect(self):
        if self.pool and not self.pool.closed:
            await self.pool.close()
            logger.info("Database connection pool closed.")
        else:
            logger.info("Database connection pool was not open or already closed.")
        self.pool = None  # Reset pool
        self.checkpointer = None  # Reset checkpointer

    def get_checkpointer(self) -> AsyncPostgresSaver:
        if not self.checkpointer:
            # This implies connect() was never called or failed.
            # The application should typically ensure connect() is called at startup.
            raise RuntimeError("Checkpointer not initialized. Call connect() first.")
        return self.checkpointer

    def get_pool(self) -> AsyncConnectionPool:
        if not self.pool or self.pool.closed:
            # Similar to get_checkpointer, implies connect() issues.
            raise RuntimeError(
                "Database pool not initialized or is closed. Call connect() first."
            )
        return self.pool


# Original connection_kwargs
connection_kwargs = {
    "autocommit": True,
    "prepare_threshold": 0,  # As per your original code
}

# Example instantiation (assuming settings are appropriately configured)
# You would adjust these values or pull them from your `settings` object
db = PostgresDb(
    settings.POSTGRES_URL,
    max_pool_size=settings.POSTGRES_MAX_POOL_SIZE,
    min_pool_size=getattr(
        settings, "POSTGRES_MIN_POOL_SIZE", 5
    ),  # Example: make min_size configurable
    connection_kwargs=connection_kwargs,
    max_connect_retries=getattr(settings, "POSTGRES_CONNECT_MAX_RETRIES", 3),
    connect_retry_delay=getattr(settings, "POSTGRES_CONNECT_RETRY_DELAY", 5.0),
)
