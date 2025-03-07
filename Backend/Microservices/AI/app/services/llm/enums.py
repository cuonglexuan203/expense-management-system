from enum import Enum
from typing import Tuple


class LLMProvider(Enum):
    OPENAI = "openai"
    GROQ = "groq"
    DEEPSEEK = "deepseek"
    GEMINI = "google"


class LLMModel(Enum):
    # OpenAI models
    GPT_4O = "gpt-4o"
    GPT_4O_MINI = "gpt-4o-mini"

    # Groq models
    LLAMA3_8B = "llama3-8b"
    LLAMA3_70B = "llama3-70b"
    LLAMA31_8B = "llama3.1-8b"
    LLAMA31_70B = "llama3.1-70b"

    # DeepSeek models
    DEEPSEEK_CODER = "deepseek-coder"
    DEEPSEEK_LLM = "deepseek-llm"

    # Google models
    GEMINI_15_FLASH = "gemini-1.5-flash"
    GEMINI_15_PRO = "gemini-1.5-pro"

    # Mapping providers to their models
    PROVIDER_MODELS = {
        LLMProvider.OPENAI: (GPT_4O, GPT_4O_MINI),
        LLMProvider.GROQ: (LLAMA3_8B, LLAMA3_70B, LLAMA31_8B, LLAMA31_70B),
        LLMProvider.DEEPSEEK: (DEEPSEEK_LLM, DEEPSEEK_CODER),
        LLMProvider.GEMINI: (GEMINI_15_FLASH, GEMINI_15_PRO),
    }

    @classmethod
    def for_provider(cls, provider: LLMProvider) -> Tuple[LLMProvider]:
        """Return all models for a specific provider"""

        return cls.PROVIDER_MODELS.get(provider, ())
