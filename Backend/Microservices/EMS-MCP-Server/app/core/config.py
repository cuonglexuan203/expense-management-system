from pydantic_settings import BaseSettings, SettingsConfigDict


class Settings(BaseSettings):
    # Application Configurations
    PROJECT_NAME: str = "EMS MCP Server"
    PROJECT_DESCRIPTION: str = "MCP Server for EMS Backend"
    VERSION: str = "0.1.0"
    DEBUG_MODE: bool = False
    LOG_LEVEL: str = "INFO"
    LOG_PATH: str = "logs"
    SERVER_HOST: str = "127.0.0.1"
    SERVER_PORT: int = 6277
    API_V1_STR: str = "/api/v1"
    ALLOWED_HOSTS: list[str] = ["http://localhost:6274"]
    API_KEY: str = ""
    MCP_SERVER_NAME: str = "EMS MCP Server"

    # Backend Configurations
    BACKEND_BASE_URL: str = "http://localhost:8000"
    BACKEND_API_KEY: str = ""

    model_config = SettingsConfigDict(
        env_file=".env", env_file_encoding="utf-8", case_sensitive=True
    )


settings = Settings()
