from app.core.exceptions import LLMProviderNotFoundError
from app.schemas.llm import LLMConfig
from app.services.llm import LLMRegistry
from app.services.llm.enums import LLMProvider
from app.services.llm.providers.base import BaseLLMProvider


class LLMFactory:
    """
    Factory for creating LLM provider instances based on configuration.
    Allows dynamic switching between different LLM providers.
    """

    @staticmethod
    def create(config: LLMConfig) -> any:
        """
        Create an LLM instance based on the provided configuration.

        Args:
            config: LLMConfig instance containing provider name, model name and parameters

        Returns:
            An initialized LLM provider instance

        Raises:
            ProviderNotFoundError: If the requested provider is not registered
            ModelNotFoundError: If the requested model is not available for the provider
        """
        provider_cls = LLMRegistry.get_provider(config.provider)

        if not provider_cls:
            raise LLMProviderNotFoundError(
                f"Provider '{config.provider}' is not registered"
            )

        provider: BaseLLMProvider = provider_cls()

        if not provider.is_model_available(config.model):
            raise ModuleNotFoundError(
                f"Model '{config.model}' is not available for provider '{config.provider}'"
            )

        return provider.get_model(
            model_type=config.model,
            temprature=config.temperature,
            max_tokens=config.max_tokens,
            **config.extra_params,
        )

    @staticmethod
    def list_available_providers():
        """Returns a list of all registered provider names."""
        return list(LLMRegistry.providers.keys())

    @staticmethod
    def list_available_models(provider_name: LLMProvider) -> list:
        """
        Tuple all available models for a specific provider.

        Args:
            provider: the provider

        Returns:
            Tuple of available model names

        Raises:
            LLMProviderNotFoundError: If the provider is not registered
        """

        provider_cls = LLMRegistry.get_provider(provider_name)

        if not provider_cls:
            raise LLMProviderNotFoundError(
                f"Provider '{provider_name}' is not registered"
            )

        provider: BaseLLMProvider = provider_cls()
        return provider.list_available_models()
