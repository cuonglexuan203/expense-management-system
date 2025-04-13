import datetime
from enum import Enum
from pydantic import BaseModel, Field


class TransactionType(Enum):
    Expense = "Expense"
    Income = "Income"


class Transaction(BaseModel):
    name: str = Field(default=None, description="Name of the item.")
    category: str | None = Field(
        default=None,
        description="Category of the item (from available categories, omit if no match).",
    )
    type: str = Field(default=None, fdescription="Transaction type ('Expense' or 'Income').")
    amount: float = Field(default=None, description="Monetary amount.")
    currency: str = Field(default="USD", description="Currency code (ISO format).")
    occurred_at: str = Field(
        default=datetime.datetime.now(datetime.timezone.utc).isoformat(),
        description="Transaction timestamp (ISO format, use current time if not specified).",
    )
