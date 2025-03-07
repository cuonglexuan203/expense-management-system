from typing import Dict, Any, Optional
from pydantic import BaseModel, Field, field_validator

from app.services.llm.enums import LLMProvider, LLMModel


class LLMConfig(BaseModel):
    """
    Configuration for LLM providers and models.
    This class defines the parameters needed to initialize an LLM.
    """

    provider: LLMProvider = Field(
        description="The LLM provider to use (e.g., 'openai', 'groq', 'deepseek', 'gemini')"
    )

    model: LLMModel = Field(
        description="The model name to use from the specified provider"
    )

    temperature: float = Field(
        default=0.7,
        ge=0.0,
        le=2.0,
        description="Sampling temperature (0.0 to 2.0). Lower is more deterministic, higher is more creative.",
    )

    max_tokens: Optional[int] = Field(
        default=None,
        description="Maximum number of tokens to generate. None means use the model's default.",
    )

    extra_params: Dict[str, Any] = Field(
        default_factory=dict,
        description="Additional provider-specific parameters to pass to the model",
    )

    @field_validator("provider")
    def validate_provider(cls, v):
        """Validate the provider name."""
        if isinstance(v, LLMProvider):
            return v

        try:
            return LLMProvider(v)
        except ValueError:
            valid_providers = [provider.value for provider in LLMProvider]
            raise ValueError(f"Provider must be one of: {', '.join(valid_providers)}")

    @field_validator("model")
    def validate_model(cls, v, info):
        """Validate the model."""
        if isinstance(v, LLMModel):
            return v

        try:
            # Try to convert string to enum
            return LLMModel(v)
        except ValueError:
            valid_models = [model.value for model in LLMModel]
            raise ValueError(f"Model must be one of: {', '.join(valid_models)}")

    class Config:
        """Pydantic config."""

        extra = "forbid"  # Forbid extra attributes
        json_schema_extra = {
            "examples": [
                {
                    "provider": "openai",
                    "model": "gpt-4-turbo",
                    "temperature": 0.7,
                    "max_tokens": 1024,
                    "extra_params": {"top_p": 0.95},
                },
                {
                    "provider": "groq",
                    "model": "llama3-70b-8192",
                    "temperature": 0.5,
                    "max_tokens": 2048,
                },
            ]
        }
