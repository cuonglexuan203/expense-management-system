from typing import Any
import httpx
from app.core.logging import get_logger
from app.core.config import settings
from app.core.security import API_KEY_NAME
from urllib.parse import urljoin

from app.services.backend.endpoints import BackendEndpoints

logger = get_logger(__name__)


class BackendClient:
    """Client for interacting with the ASP.NET Core backend."""

    def __init__(self):
        self.base_url = settings.BACKEND_BASE_URL
        self.api_key = settings.BACKEND_API_KEY
        self.headers = {API_KEY_NAME: self.api_key, "Content-Type": "application/json"}

    def _build_url(self, endpoint_path: str, **kwargs) -> str:
        """Build a complete URL for a given endpoint with optional format parameters."""
        if kwargs:
            endpoint_path = endpoint_path.format(**kwargs)

        return urljoin(self.base_url, endpoint_path)

    async def get(
        self, endpoint_path: str, params: dict[str, Any] | None = None, **kwargs
    ) -> dict[str, Any]:
        url = self._build_url(endpoint_path, **kwargs)

        async with httpx.AsyncClient() as client:
            logger.debug(f"Get request to {url}")
            response = await client.get(url, headers=self.headers, params=params)
            response.raise_for_status()
            return response.json()

    async def post(
        self, endpoint_path: str, data: dict[str, Any], **kwargs
    ) -> dict[str, Any]:
        url = self._build_url(endpoint_path, **kwargs)

        async with httpx.AsyncClient() as client:
            logger.debug(f"Post request to {url}")
            response = await client.post(url, headers=self.headers, json=data)
            response.raise_for_status()
            return response.json()

    async def get_categories(self) -> dict[str, Any]:
        return await self.get(BackendEndpoints.CATEGORIES)

    async def get_user_preferences(self, user_id: str) -> dict[str, Any]:
        return await self.get(BackendEndpoints.USER_PREFERENCES, user_id=user_id)

    async def get_currency_slang(self, currency_code: str) -> dict[str, Any]:
        return await self.get(
            BackendEndpoints.CURRENCY_SLANGS, currency_code=currency_code
        )
