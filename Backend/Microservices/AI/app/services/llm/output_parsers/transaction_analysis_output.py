from typing import List, Optional
from pydantic import BaseModel, Field
from langchain.output_parsers import PydanticOutputParser
from app.schemas.notification import Notification
from app.schemas.transaction import Transaction


class TransactionAnalysisOutput(BaseModel):
    transactions: List[Transaction] = Field(
        description="List of categorized transactions from the query"
    )
    introduction: str = Field(
        description="A funny and friendly text about the financial transactions"
    )
    notification: Optional[Notification] = Field(
        description="The notification containing information about the analysis to push to the user"
    )


transaction_parser = PydanticOutputParser(pydantic_object=TransactionAnalysisOutput)
