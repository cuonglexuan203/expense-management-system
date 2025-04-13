from pydantic import BaseModel, Field


class Transaction(BaseModel):
    name: str = None
    category: str = None
    type: str = None
    amount: float = None
    currency: str = None
    occurred_at: str = None


class FinancialResponse(BaseModel):
    """Response model for financial agent."""

    transactions: list[Transaction] = Field(
        default=None, description="List of available transactions"
    )
    introduction: str = Field(description="LLM introduction message in markdown format")
    # message: str
