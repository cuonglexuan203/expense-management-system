from typing import List, Optional
from pydantic import BaseModel, Field
from langchain.output_parsers import PydanticOutputParser


class CategorizedItem(BaseModel):
    name: str = Field(description="Name of the item from the user query")
    category: str = Field(description="Category like breakfast, lunch, salary, etc.")
    type: str = Field(description="Transaction type, either 'expense' or 'income'")
    amount: float = Field(description="Monetary amount of the transaction")
    currency: str = Field(default="USD", description="Currency code in ISO format")


class TransactionAnalysisOutput(BaseModel):
    categorized_items: List[CategorizedItem] = Field(
        description="List of categorized transactions from the query"
    )
    transaction_type: Optional[str] = Field(
        description="Dominant transaction type (expense/income) if clear"
    )
    introduction: str = Field(
        description="LLM-generated summary of the financial transactions"
    )
    total_expenses: Optional[float] = Field(
        description="Total sum of all expenses in the query"
    )
    total_income: Optional[float] = Field(
        description="Total sum of all income in the query"
    )


transaction_parser = PydanticOutputParser(pydantic_object=TransactionAnalysisOutput)
