import datetime
from enum import Enum
from pydantic import BaseModel, Field


class TransactionType(Enum):
    Expense = "Expense"
    Income = "Income"


class Transaction(BaseModel):
    name: str = Field(description="Name of the item from the user query")
    category: str | None = Field(
        default=None,
        description="Category in available categories. Do not refer in output if do not match any",
    )
    type: str = Field(
        description="Transaction type, either exactly 'Expense' or 'Income'"
    )
    amount: float = Field(description="Monetary amount of the transaction")
    currency: str = Field(default="USD", description="Currency code in ISO format")
    occurred_at: str = Field(
        default=datetime.datetime.now(datetime.timezone.utc),
        description="The time when the transaction occurred, using current time if not mentioned",
    )
