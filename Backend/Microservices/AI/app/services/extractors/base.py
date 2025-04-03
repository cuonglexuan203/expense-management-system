from abc import ABC, abstractmethod
from typing import Any

from app.schemas.llm_config import LLMConfig
from app.services.backend.client import BackendClient
from app.services.llm.factory import LLMFactory
from app.services.llm.output_parsers.transaction_analysis_output import (
    TransactionAnalysisOutput,
)
from langchain.schema.language_model import BaseLanguageModel


class BaseExtractor(ABC):
    """Base class for transaction extractors."""

    def __init__(self, llm_config: LLMConfig):
        self.backend_client = BackendClient()
        self.llm_config = llm_config

    @abstractmethod
    async def extract(
        self, user_id: str, input_data: dict[str, Any]
    ) -> TransactionAnalysisOutput:
        """Extract transactions from the input data."""
        pass

    def create_llm(self) -> BaseLanguageModel:
        """Create LLM instance."""
        return LLMFactory.create(self.llm_config)
