from langchain_google_genai import ChatGoogleGenerativeAI
from app.services.llm.enums import LLMProvider, LLMModel
from app.services.llm.providers.base import BaseLLMProvider
from app.services.llm.registry import register_provider
from app.core.config import settings


@register_provider(LLMProvider.GOOGLE)
class GoogleProvider(BaseLLMProvider):
    """Provider implementation for Google Gemini models."""

    # Available models mapping
    AVAILABLE_MODELS = LLMModel.for_provider(LLMProvider.GOOGLE)

    def get_model(
        self, model_type, temperature=0.7, max_tokens=None, **kwargs
    ) -> ChatGoogleGenerativeAI:
        """Get a Gemini model instance with specified parameters."""
        api_key = settings.GOOGLE_API_KEY

        generation_config = {}
        if max_tokens:
            generation_config["max_tokens"] = max_tokens

        if "top_p" in kwargs:
            generation_config["top_p"] = kwargs.pop("top_p")
        if "top_k" in kwargs:
            generation_config["top_k"] = kwargs.pop("top_k")

        return ChatGoogleGenerativeAI(
            model=model_type.value,
            temperature=temperature,
            google_api_key=api_key,
            generation_config=generation_config,
            **kwargs
        )

    def list_available_models(self):
        """List all available Gemini models."""
        return self.AVAILABLE_MODELS
