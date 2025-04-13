from pydantic import BaseModel, Field


class EventResponse(BaseModel):
    introduction: str = Field(description="LLM-based event scheduling agent message")
