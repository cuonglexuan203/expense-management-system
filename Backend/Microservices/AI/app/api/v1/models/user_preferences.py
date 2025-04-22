from enum import Enum
from pydantic import BaseModel, Field


class CurrencyCode(str, Enum):
    USD = "United States Dollar"
    EUR = "Euro"
    JPY = "Japanese Yen"
    CNY = "Chinese Yuan"
    KRW = "South Korean Won"
    VND = "Viet Nam Dong"


class UserPreferences(BaseModel):
    # user_id: str
    language_code: str = Field(description="User language")
    currency_code: str = Field(description="Currency code of user ex. USD, VND, CNY, KRW, JPY,...")
