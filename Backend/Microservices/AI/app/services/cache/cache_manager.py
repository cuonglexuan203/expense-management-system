from functools import wraps
import json
from typing import Callable, Type, TypeVar
from pydantic import BaseModel
from redis.asyncio import Redis
from app.core.config import settings
from app.core.logging import get_logger
from app.services.cache.cache_key_generator import CacheKeyGenerator


logger = get_logger(__name__)


T = TypeVar("T", bound=BaseModel)


class CacheManager:

    def __init__(self):
        self.redis_url = settings.REDIS_URL
        self.password = settings.REDIS_PASSWORD
        self.ttl = settings.REDIS_TTL
        self._redis_client: Redis | None = None
        self.instance_name = settings.REDIS_INSTANCE_NAME

    async def get_redis(self) -> Redis:
        if self._redis_client is None:
            logger.info("Initializing Redis connection")
            try:
                self._redis_client = Redis.from_url(
                    self.redis_url, password=self.password
                )
                logger.info("Redis connection initialized successfully")
            except Exception as e:
                logger.error(f"Failed to initialize Redis connection: {str(e)}")
                raise

        return self._redis_client

    async def close(self):
        if self._redis_client:
            await self._redis_client.close()
            self._redis_client = None

    def get_full_key(self, key: str) -> str:
        return f"{self.instance_name}:{key}" if self.instance_name else key

    async def get(self, key: str) -> str | None:
        redis = await self.get_redis()
        return await redis.get(self.get_full_key(key))

    async def set(self, key: str, value: str, ttl: int | None = None) -> bool:
        redis = await self.get_redis()
        return await redis.set(self.get_full_key(key), value, ex=ttl or self.ttl)

    async def delete(self, key: str) -> int:
        redis = await self.get_redis()
        return await redis.delete(self.get_full_key(key))

    async def get_model(self, key: str, model_class: Type[T]) -> T | None:
        data = await self.get(key)

        if data is None:
            return None

        try:
            return model_class.model_validate_json(data)
        except Exception as e:
            logger.error(f"Error deserializing cached data: {e}")
            await self.delete(key)

    async def set_model(
        self, key: str, model: BaseModel, ttl: int | None = None
    ) -> bool:
        return await self.set(key, model.model_dump_json(), ttl)

    async def clear_pattern(self, pattern: str) -> int:
        redis = await self.get_redis()
        try:
            keys = await redis.keys(pattern)
            full_keys = [self.get_full_key(key) for key in keys]
            if keys:
                return await redis.delete(*full_keys)
            return 0
        except Exception as e:
            logger.error(f"Error clearing keys from Redis: {str(e)}")
            return 0

    async def get_or_set_model(
        self, key: str, factory: Callable, ttl: int | None = None
    ) -> T:
        cached_data = await self.get_model(key, T)

        if cached_data is not None:
            logger.info(f"Cache hit for key: {key}")
            return cached_data

        logger.info(f"Cache miss for key: {key}")
        data = await factory()

        if data is not None:
            await self.set_model(key, data, ttl)

        return data

    async def get_or_set(self, key: str, factory: Callable, ttl: int | None = None):
        cached_data = await self.get(key)

        if cached_data is not None:
            logger.info(f"Cache hit for key: {key}")
            return cached_data

        logger.info(f"Cache miss for key: {key}")
        data = await factory()

        if data is not None:
            serialized_data = json.dumps(data)
            await self.set(key, serialized_data, ttl)

        return data


cache_manager = CacheManager()


def cached(prefix: str, ttl: int | None = None):
    def decorator(func):
        @wraps(func)
        async def wrapper(*args, **kwargs):
            cache_key = CacheKeyGenerator.generate_key(prefix, *args, **args)

            async def factory():
                return await func(*args, **kwargs)

            return await cache_manager.get_or_set(
                key=cache_key, factory=factory, ttl=ttl
            )

        return wrapper

    return decorator
