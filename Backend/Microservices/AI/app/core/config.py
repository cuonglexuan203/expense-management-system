from typing import List
from pydantic_settings import BaseSettings


class Settings(BaseSettings):
    # Application settings
    PROJECT_NAME: str = "AI LLM Server"
    PROJECT_DESCRIPTION: str = (
        "FastAPI server for multi-provider LLM integration \
        with RAG and agent capabilities"
    )
    VERSION: str = "0.1.0"
    DEBUG_MODE: bool = False
    LOG_LEVEL: str = "INFO"
    SERVER_HOST: str = "0.0.0.0"
    SERVER_PORT: int = 8000
    API_V1_STR: str = "/api/v1"
    ALLOWED_HOSTS: List[str] = ["http://localhost:3000"]

    OPENAI_API_KEY: str = ""
    GROQ_API_KEY: str = ""
    GOOGLE_API_KEY: str = ""


settings = Settings()
