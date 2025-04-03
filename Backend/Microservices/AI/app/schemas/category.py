from enum import Enum
from uuid import UUID
from pydantic import BaseModel

from app.schemas.transaction import TransactionType


class CategoryType(Enum):
    Default = "Default"
    Custom = "Custom"


class Category(BaseModel):
    id: int
    name: str
    is_default: bool
    type: CategoryType
    financial_flow_type: TransactionType
    icon_id: UUID | None = None
    icon_url: str | None = None
