from pydantic import BaseModel, Field
from app.api.v1.models.user_preferences import UserPreferences


class AssistantRequest(BaseModel):
    """Request model for assistant."""

    chat_thread_id: int = Field(description="Chat thread id")
    user_id: str = Field(description="Unique identifier of the user")
    message: str | None = Field(default="", description="Optional text message context")
    file_urls: list[str] = Field(description="File urls")
    categories: list[str] = Field(description="The available categories")
    user_preferences: UserPreferences = Field(
        description="The user preferences: currency code, language"
    )
