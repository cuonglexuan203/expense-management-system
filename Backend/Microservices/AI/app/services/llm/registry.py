from typing import Optional, Type

from app.services.llm.enums import LLMProvider


class LLMRegistry:
    """Registry for LLM provider classes."""

    providers: dict[LLMProvider, Type] = {}

    @classmethod
    def register(cls, name: LLMProvider) -> callable:
        """
        Decorator to register a provider class.

        Args:
            name: The name to register the provider under

        Returns:
            Decorator function
        """

        def decorator(provider_cls: Type) -> Type:
            cls.providers[name] = provider_cls
            return provider_cls

        return decorator

    @classmethod
    def get_provider(cls, name: LLMProvider) -> Optional[Type]:
        """
        Get a provider class by name.

        Args:
            name: The name of the provider

        Returns:
            The provider class if found, None otherwise
        """
        return cls.providers.get(name)


def register_provider(name: LLMProvider) -> callable:
    """
    Convenience function for registering a provider.

    Args:
        name: The name to register the provider under

    Returns:
        Decorator function
    """
    return LLMRegistry.register(name)
