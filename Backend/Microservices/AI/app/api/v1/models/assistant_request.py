from pydantic import BaseModel, Field
from app.api.v1.models.user_preferences import UserPreferences


class AssistantRequest(BaseModel):
    """Request model for assistant."""

    user_id: str = Field(description="Unique identifier of the user")
    wallet_id: int = Field(description="Unique identifier of the wallet")
    chat_thread_id: int = Field(description="Chat thread id")
    time_zone_id: str = Field(description="IANA Timezone ID string")
    message: str | None = Field(
        default=None, description="Optional text message context"
    )
    file_urls: list[str] = Field(default=None, description="File urls")
    categories: list[str] = Field(default=None, description="The available categories")
    user_preferences: UserPreferences = Field(
        default=None, description="The user preferences: currency code, language"
    )
