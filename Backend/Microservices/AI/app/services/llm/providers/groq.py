from app.core.config import settings
from app.services.llm.enums import LLMProvider, LLMModel
from app.services.llm.providers.base import BaseLLMProvider
from app.services.llm.registry import register_provider
from langchain_groq import ChatGroq


@register_provider(LLMProvider.GROQ)
class GroqProvider(BaseLLMProvider):
    """Provider implementation for Groq models."""

    # Available models mapping
    AVAILABLE_MODELS = LLMModel.for_provider(LLMProvider.GROQ)

    def get_model(self, model_type, temperature=0.7, max_tokens=None, **kwargs) -> ChatGroq:
        """Get a Groq model instance with specified parameters."""
        api_key = settings.GROQ_API_KEY

        model_kwargs = {}
        if max_tokens:
            model_kwargs["max_tokens"] = max_tokens

        model_kwargs.update(kwargs)

        return ChatGroq(
            model_name=model_type.value,
            temperature=temperature,
            groq_api_key=api_key,
            model_kwargs=model_kwargs,
        )

    def list_available_models(self):
        """List all available Groq models."""
        return self.AVAILABLE_MODELS
