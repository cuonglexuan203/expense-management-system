from fastapi import APIRouter
from langchain_core.output_parsers import JsonOutputParser
from app.api.v1.models import Transaction
from app.schemas.llm_config import LLMConfig
from app.services.llm.output_parsers.transaction_analysis_output import (
    TransactionAnalysisOutput,
)
from app.services.agents.prompts.transaction import TEST_PROMP
from langchain_core.prompts import PromptTemplate
from app.services.llm.enums import LLMModel, LLMProvider
from app.services.llm.factory import LLMFactory

router = APIRouter()


@router.get("/")
def Test():
    return {"count": 1}


@router.post("/analyze-transaction")
async def analyze_transaction(transaction: Transaction):
    model = LLMFactory.create(
        LLMConfig(provider=LLMProvider.OPENAI, model=LLMModel.GPT_4O_MINI, temperature=0)
    )

    parser = JsonOutputParser(pydantic_object=TransactionAnalysisOutput)

    prompt = PromptTemplate(
        input=["input"],
        template=TEST_PROMP,
        partial_variables={"format_instructions": parser.get_format_instructions()},
    )

    chain = prompt | model | parser
    res = chain.invoke({"input": transaction.query})

    return res
