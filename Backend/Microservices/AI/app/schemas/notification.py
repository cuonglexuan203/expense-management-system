from pydantic import BaseModel, Field


class Notification(BaseModel):
    title: str = Field(description="An interesting title of the notification.")
    body: str = Field(description="A short, friendly finance-related summary with a light question \
        that both encourages and reminds users to add their transactions into the app.")
