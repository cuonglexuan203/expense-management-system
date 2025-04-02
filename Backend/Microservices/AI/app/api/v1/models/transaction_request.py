from typing import Any
from pydantic import BaseModel, Field

from app.api.v1.models.user_preferences import UserPreferences


class TextTransactionRequest(BaseModel):
    """Request model for text-based transaction extraction."""

    user_id: str = Field(description="Unique identifier of the user")
    message: str = Field(description="User's text message to extract transactions from")
    categories: list[str] = Field(description="The available categories")
    user_preferences: UserPreferences = Field(
        description="The user preferences: currency code, language"
    )


class ImageTransactionRequest(BaseModel):
    """Request model for image-based transaction extraction."""

    user_id: str = Field(description="Unique identifier of the user")
    image_data: str = Field(description="Base64 encoded image data or bytes")
    message: str | None = Field(default="", description="Optional text message context")
    categories: list[str] = Field(description="The available categories")
    user_preferences: dict[str, Any] = Field(
        description="The user preferences: currency code, language"
    )


class AudioTransactionRequest(BaseModel):
    """Request model for audio-based transaction extraction."""

    user_id: str = Field(description="Unique identifier of the user")
    audio_data: str = Field(description="Base64 encoded audio data or bytes")
    message: str | None = Field(default="", description="Optional text message context")
    categories: list[str] = Field(description="The available categories")
    user_preferences: dict[str, Any] = Field(
        description="The user preferences: currency code, language"
    )
