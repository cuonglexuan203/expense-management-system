from app.core.config import settings
from typing import Optional
from langchain_openai import ChatOpenAI
from app.services.llm.enums import LLMProvider, LLMModel
from app.services.llm.providers.base import BaseLLMProvider
from app.services.llm.registry import register_provider


@register_provider(LLMProvider.OPENAI)
class OpenAIProvider(BaseLLMProvider):
    """Provider implementation for OpenAI models."""

    # Available models mapping
    AVAILABLE_MODELS = LLMModel.for_provider(LLMProvider.OPENAI)

    def get_model(
        self,
        model_type: LLMModel,
        temperature: float = 0.7,
        max_tokens: Optional[int] = None,
        **kwargs
    ) -> ChatOpenAI:
        """Get an OpenAI model instance with specified parameters."""
        api_key = settings.OPENAI_API_KEY

        model_kwargs = {}
        if max_tokens:
            model_kwargs["max_tokens"] = max_tokens

        model_kwargs.update(kwargs)

        return ChatOpenAI(
            model=model_type.value,
            temperature=temperature,
            api_key=api_key,
            model_kwargs=model_kwargs,
        )

    def list_available_models(self):
        """List all available OpenAI models."""
        return self.AVAILABLE_MODELS
