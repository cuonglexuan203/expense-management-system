from enum import Enum
from typing import Tuple


class LLMProvider(Enum):
    OPENAI = "openai"
    GROQ = "groq"
    DEEPSEEK = "deepseek"
    GOOGLE = "google"


class LLMModel(Enum):
    # ------------------ OpenAI models ------------------
    GPT_4O_MINI = "gpt-4o-mini"
    GPT_4O_MINI_AUDIO_PREVIEW = "gpt-4o-mini-audio-preview"

    # ------------------ Groq models ------------------
    # (Meta)
    LLAMA3_8B_8192 = "llama3-8b-8192"
    LLAMA3_70B_8192 = "llama3-70b-8192"
    LLAMA33_70B_VERSATILE = "llama-3.3-70b-versatile"
    LLAMA31_8B_INSTANT = "llama-3.1-8b-instant"
    LLAMA_GUARD_3_8B = "llama-guard-3-8b"
    # GEMMA2_9B_IT = "gemma2-9b-it"

    # Mistral models
    MIXTRAL_8X7B_32768 = "mixtral-8x7b-32768"

    # Whisper models
    WHISPER_LARGE_V3 = "whisper-large-v3"
    WHISPER_LARGE_V3_TURBO = "whisper-large-v3-turbo"

    # Hugging Face model
    DISTIL_WHISPER_LARGE_V3_EN = "distil-whisper-large-v3-en"

    # ------------------ Google models ------------------
    # Gemini 2 models
    GEMINI_20_FLASH = "gemini-2.0-flash"
    GEMINI_20_FLASH_LITE = "gemini-2.0-flash-lite"
    GEMINI_20_PRO_EXP_0205 = "gemini-2.0-pro-exp-02-05"
    GEMINI_20_FLASH_THINKING_EXP = "gemini-2.0-flash-thinking-exp-01-21"

    # Gemini 1.5 models
    GEMINI_15_PRO = "gemini-1.5-pro"
    GEMINI_15_FLASH = "gemini-1.5-flash"
    GEMINI_15_FLASH_8B = "gemini-1.5-flash-8b"

    # Preview models
    GEMINI_20_FLASH_EXP = "gemini-2.0-flash-exp"

    # ------------------ DeepSeek models ------------------
    DEEPSEEK_CODER = "deepseek-coder"
    DEEPSEEK_LLM = "deepseek-llm"

    @classmethod
    def for_provider(cls, provider: LLMProvider) -> Tuple["LLMModel", ...]:
        """Return all models for a specific provider"""
        mapping = {
            LLMProvider.OPENAI: (cls.GPT_4O_MINI, cls.GPT_4O_MINI_AUDIO_PREVIEW),
            LLMProvider.GROQ: (
                cls.LLAMA3_8B_8192,
                cls.LLAMA3_70B_8192,
                cls.LLAMA33_70B_VERSATILE,
                cls.LLAMA31_8B_INSTANT,
                cls.LLAMA_GUARD_3_8B,
                cls.MIXTRAL_8X7B_32768,
            ),
            LLMProvider.DEEPSEEK: (cls.DEEPSEEK_LLM, cls.DEEPSEEK_CODER),
            LLMProvider.GOOGLE: (
                cls.GEMINI_15_PRO,
                cls.GEMINI_15_FLASH,
                cls.GEMINI_15_FLASH_8B,
                cls.GEMINI_20_FLASH,
                cls.GEMINI_20_FLASH_LITE,
                cls.GEMINI_20_PRO_EXP_0205,
                cls.GEMINI_20_FLASH_THINKING_EXP,
                cls.GEMINI_20_FLASH_EXP,
            ),
        }
        return mapping.get(provider, ())
