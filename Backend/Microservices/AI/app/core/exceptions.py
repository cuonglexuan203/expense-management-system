from typing import Any, Dict, Optional

from fastapi import status


class BaseException(Exception):
    """Base exception for AI server."""

    def __init__(
        self,
        message: str,
        status_code: int = status.HTTP_500_INTERNAL_SERVER_ERROR,
        details: Optional[Dict[str, Any]] = None,
    ):
        self.message = message
        self.status_code = status_code
        self.details = details
        super().__init__(self.message)


class LLMProviderNotFoundError(BaseException):
    """Exception raised when an LLM provider is not supported."""

    def __init__(
        self,
        message: str = "LLM Provider not found",
        provider: Optional[str] = None,
        details: Optional[Dict[str, Any]] = None,
    ):
        provider_info = {}
        if provider:
            provider_info["provider"] = provider

        error_details = provider_info
        if details:
            error_details.update(details)

        super.__init__(
            message=message,
            status_code=status.HTTP_404_NOT_FOUND,
            details=error_details,
        )


class LLMModelNotFoundError(BaseException):
    """Exception raised when an LLM model is not supported by the provider."""

    def __init__(
        self,
        message: str = "LLM Model not found",
        model: Optional[str] = None,
        details: Optional[Dict[str, Any]] = None,
    ):
        provider_info = {}
        if model:
            provider_info["model"] = model

        error_details = provider_info
        if details:
            error_details.update(details)

        super.__init__(
            message=message,
            status_code=status.HTTP_404_NOT_FOUND,
            details=error_details,
        )
