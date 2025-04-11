from pydantic import BaseModel, Field

from app.api.v1.models.user_preferences import UserPreferences


class TextTransactionRequest(BaseModel):
    """Request model for text-based transaction extraction."""

    chat_thread_id: int = Field(description="Chat thread id")
    user_id: str = Field(description="Unique identifier of the user")
    message: str = Field(description="User's text message to extract transactions from")
    categories: list[str] = Field(description="The available categories")
    user_preferences: UserPreferences = Field(
        description="The user preferences: currency code, language"
    )


class ImageTransactionRequest(BaseModel):
    """Request model for image-based transaction extraction."""

    chat_thread_id: int = Field(description="Chat thread id")
    user_id: str = Field(description="Unique identifier of the user")
    message: str | None = Field(default="", description="Optional text message context")
    file_urls: list[str] = Field(description="Image urls")
    categories: list[str] = Field(description="The available categories")
    user_preferences: UserPreferences = Field(
        description="The user preferences: currency code, language"
    )


class AudioTransactionRequest(BaseModel):
    """Request model for audio-based transaction extraction."""

    chat_thread_id: int = Field(description="Chat thread id")
    user_id: str = Field(description="Unique identifier of the user")
    message: str | None = Field(default="", description="Optional text message context")
    file_urls: list[str] = Field(description="Image urls")
    categories: list[str] = Field(description="The available categories")
    user_preferences: UserPreferences = Field(
        description="The user preferences: currency code, language"
    )
