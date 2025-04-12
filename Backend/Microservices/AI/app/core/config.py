from pydantic_settings import BaseSettings, SettingsConfigDict


class Settings(BaseSettings):
    # Application Configurations
    PROJECT_NAME: str = "AI LLM Server"
    PROJECT_DESCRIPTION: str = (
        "FastAPI server for multi-provider LLM integration \
        with RAG and agent capabilities"
    )
    VERSION: str = "0.1.0"
    DEBUG_MODE: bool = False
    LOG_LEVEL: str = "INFO"
    LOG_PATH: str = "logs"
    SERVER_HOST: str = "127.0.0.1"
    SERVER_PORT: int = 8000
    API_V1_STR: str = "/api/v1"
    ALLOWED_HOSTS: list[str] = ["http://localhost:3000"]
    API_KEY: str = ""

    OPENAI_API_KEY: str = ""
    GROQ_API_KEY: str = ""
    GOOGLE_API_KEY: str = ""

    # Backend Configurations
    BACKEND_BASE_URL: str = "http://localhost:8000"
    BACKEND_API_KEY: str = ""

    # Redis Configurations
    REDIS_URL: str
    REDIS_PASSWORD: str
    REDIS_TTL: int = 3600  # 1 hour
    REDIS_INSTANCE_NAME: str | None = None

    # Postgres Configurations
    POSTGRES_URL: str = ""
    POSTGRES_MAX_POOL_SIZE: int

    model_config = SettingsConfigDict(
        env_file=".env", env_file_encoding="utf-8", case_sensitive=True, extra="allow"
    )


settings = Settings()
