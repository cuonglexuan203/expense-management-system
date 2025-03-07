from pydantic import BaseModel


class Transaction(BaseModel):
    query: str
