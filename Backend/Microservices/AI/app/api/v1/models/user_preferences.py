from pydantic import BaseModel, Field


class UserPreferences(BaseModel):
    # user_id: str
    language: str = Field(description="user language")
    currency_code: str = Field(description="currency code of user")
