from typing import List
from pydantic import BaseModel, Field
from langchain.output_parsers import PydanticOutputParser

from app.schemas.transaction import Transaction


class TransactionAnalysisOutput(BaseModel):
    transactions: List[Transaction] = Field(
        description="List of categorized transactions from the query"
    )
    introduction: str = Field(
        description="A funny and friendly text about the financial transactions"
    )


transaction_parser = PydanticOutputParser(pydantic_object=TransactionAnalysisOutput)
