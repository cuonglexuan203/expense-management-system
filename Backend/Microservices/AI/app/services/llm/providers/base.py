from langchain.schema.language_model import BaseLanguageModel
from abc import ABC, abstractmethod
from typing import Optional, Tuple
from app.core.config import settings
from app.services.llm.enums import LLMModel


class BaseLLMProvider(ABC):
    """Base class for all LLM providers."""

    @abstractmethod
    def get_model(
        self,
        model_type: LLMModel,
        temprature: float = 0.7,
        max_tokens: Optional[int] = None,
        **kwargs,
    ) -> BaseLanguageModel:
        """
        Get a language model instance with the specified parameters.

        Args:
            model_type: The model type to use
            temperature: Sampling temperature (0.0 to 1.0)
            max_tokens: Maximum number of tokens to generate
            **kwargs: Additional provider-specific parameters

        Returns:
            Configured language model instance
        """
        pass

    @abstractmethod
    def list_available_models(self) -> Tuple[LLMModel]:
        """
        Tuple all available models for this provider.

        Returns:
            Tuple of model types
        """
        pass

    def is_model_available(self, model_type: LLMModel) -> bool:
        """
        Check if a specific model is available.

        Args:
            model_type: The model type to check

        Returns:
            True if the model is available, False otherwise
        """

        return model_type in self.list_available_models()

    def _get_api_key(self, env_var_name: str) -> str:
        """
        Get API key from environment variables.

        Args:
            env_var_name: Name of the environment variable

        Returns:
            API key value

        Raises:
            ValueError: If the API key is not found
        """

        api_key = settings[env_var_name]
        if not api_key:
            raise ValueError(
                f"API key not found. Set the {env_var_name} environment variable."
            )

        return api_key
