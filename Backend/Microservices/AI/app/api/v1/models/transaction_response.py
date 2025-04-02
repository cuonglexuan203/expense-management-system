from pydantic import BaseModel, Field

from app.schemas.transaction import Transaction


class TransactionResponse(BaseModel):
    """Response model for transaction extraction endpoints."""

    transactions: list[Transaction] = Field(
        default_factory=list, description="List of extracted transactions"
    )

    introduction: str = Field(..., description="Summary of the extraction results")
    message: str = Field(..., description="Message about the extraction process")
    # error: str | None = Field(default=None, description="Error message if any")
