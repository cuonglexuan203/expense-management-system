from typing import Annotated
from fastapi import APIRouter, Depends, HTTPException
from langchain_core.output_parsers import PydanticOutputParser
from app.api.v1.models import Transaction
from app.api.v1.models.transaction_request import (
    ImageTransactionRequest,
    TextTransactionRequest,
)
from app.api.v1.models.transaction_response import TransactionResponse
from app.core.logging import get_logger
from app.core.security import get_api_key
from app.schemas.llm_config import LLMConfig
from app.services.extractors.audio_extractor import AudioExtractor
from app.services.extractors.image_extractor import ImageExtractor
from app.services.extractors.text_extractor import TextExtractor
from app.services.graphs.ems_swarm import EMSSwarm
from app.services.llm.output_parsers.transaction_analysis_output import (
    TransactionAnalysisOutput,
)
from app.services.agents.prompts.transaction import TEST_PROMP
from langchain_core.prompts import PromptTemplate
from app.services.llm.enums import LLMModel, LLMProvider
from app.services.llm.factory import LLMFactory
from app.services.graphs.ems_supervisor import EMSSupervisor
from app.services.graphs.ems_supervisor import PROMPT2

router = APIRouter()

logger = get_logger(__name__)


@router.post("/extract-transaction", deprecated=True)
async def extract_transaction(transaction: Transaction):
    model = LLMFactory.create(
        LLMConfig(
            provider=LLMProvider.GOOGLE, model=LLMModel.GEMINI_20_FLASH, temperature=0
        )
    )

    parser = PydanticOutputParser(pydantic_object=TransactionAnalysisOutput)

    prompt = PromptTemplate(
        input=["input"],
        template=TEST_PROMP,
        partial_variables={"format_instructions": parser.get_format_instructions()},
    )

    chain = prompt | model | parser
    res = await chain.ainvoke({"input": transaction.query})
    # logger.info(res)

    return res


@router.post("/text", response_model=TransactionResponse)
async def extract_from_text(
    request: TextTransactionRequest, _: Annotated[str, Depends(get_api_key)]
):
    """Extract transactions from text message."""
    try:
        extractor = TextExtractor(
            LLMConfig(
                provider=LLMProvider.GOOGLE,
                model=LLMModel.GEMINI_20_FLASH,
                temperature=0,
            )
        )
        result = await extractor.extract(
            request.user_id,
            {
                "message": request.message,
                "categories": request.categories,
                "user_preferences": request.user_preferences,
            },
        )

        return TransactionResponse(
            transactions=result.transactions,
            introduction=result.introduction,
            message="Successfully extracted transactions from text",
        )

    except Exception as e:
        logger.error(f"Error extracting transactions from text: {e}")
        raise HTTPException(
            status_code=500, detail=f"Error extracting transactions from text: {str(e)}"
        )


@router.post("/image", response_model=TransactionResponse)
async def extract_from_image(
    request: ImageTransactionRequest, _: Annotated[str, Depends(get_api_key)]
):
    """Extract transactions from image message."""
    try:
        extractor = ImageExtractor(
            LLMConfig(
                provider=LLMProvider.GOOGLE,
                model=LLMModel.GEMINI_20_FLASH,
                temperature=0,
            )
        )
        result = await extractor.extract(
            request.user_id,
            {
                "message": request.message,
                "categories": request.categories,
                "user_preferences": request.user_preferences,
                "image_urls": request.file_urls,
            },
        )

        return TransactionResponse(
            transactions=result.transactions,
            introduction=result.introduction,
            message="Successfully extracted transactions from image",
        )

    except Exception as e:
        logger.error(f"Error extracting transactions from image: {e}")
        raise HTTPException(
            status_code=500,
            detail=f"Error extracting transactions from image: {str(e)}",
        )


@router.post("/audio", response_model=TransactionResponse)
async def extract_from_audio(
    request: ImageTransactionRequest, _: Annotated[str, Depends(get_api_key)]
):
    """Extract transactions from audio message."""
    try:
        extractor = AudioExtractor(
            LLMConfig(
                provider=LLMProvider.OPENAI,
                model=LLMModel.GPT_4O_MINI_AUDIO_PREVIEW,
                temperature=0,
            )
        )
        result = await extractor.extract(
            request.user_id,
            {
                "message": request.message,
                "categories": request.categories,
                "user_preferences": request.user_preferences,
                "audio_urls": request.file_urls,
            },
        )

        return TransactionResponse(
            transactions=result.transactions,
            introduction=result.introduction,
            message="Successfully extracted transactions from audio",
        )

    except Exception as e:
        logger.error(f"Error extracting transactions from audio: {e}")
        raise HTTPException(
            status_code=500,
            detail=f"Error extracting transactions from audio: {str(e)}",
        )


@router.post("/supervisor")
async def supervisor(request: ImageTransactionRequest):

    prompt = PROMPT2.format(
        categories=", ".join(request.categories),
        user_preferences=request.user_preferences,
        currency_code=request.user_preferences.currency_code,
        language=request.user_preferences.language or "English",
    )

    graph = EMSSupervisor(prompt).get_graph()

    result = await graph.ainvoke(
        {
            "messages": [
                {
                    "role": "user",
                    "content": request.message + f"\n\n {request.file_urls}",
                }
            ],
            "user_id": request.user_id,
            "categories": ", ".join(request.categories),
            "user_preferences": request.user_preferences,
            "currency_code": request.user_preferences.currency_code,
            "language": request.user_preferences.language or "English",
        },
        config={"configurable": {"thread_id": "1"}},
        interrupt_after=["financial_expert"],
    )

    if "messages" in result:
        for message in result["messages"]:
            message.pretty_print()

    return result


@router.post("/swarm")
async def swarm(request: ImageTransactionRequest):

    graph = EMSSwarm().get_graph()

    user_context = (
        f"User's preferences: {request.user_preferences}"
        f"User's categories: {request.categories}"
        f"Chat theard id: {request.chat_thread_id}"
    )

    result = await graph.ainvoke(
        {
            "messages": [
                {
                    "role": "user",
                    "content": request.message + f"\n\n {request.file_urls}",
                },
                {"role": "user", "content": user_context},
            ],
            "user_id": request.user_id,
            "categories": request.categories,
            "user_preferences": request.user_preferences,
        },
        config={"configurable": {"thread_id": "2"}},
    )

    if "messages" in result:
        for message in result["messages"]:
            message.pretty_print()

    return result
