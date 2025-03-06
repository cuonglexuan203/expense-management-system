import logging
from pathlib import Path
import sys
from loguru import logger
from core.config import settings


class IntercepHandler(logging.Handler):
    """
    Intercept standard logging messages and redirect them to Loguru.

    This allows libraries that use the standard logging module to have
    their logs processed by Loguru.
    """

    def emit(self, record: logging.LogRecord) -> None:
        # Get corresponding Loguru level if it exists
        try:
            level = logger.level(record.levelname).name
        except ValueError:
            level = record.levelno

        # Find caller from where the logged message originated
        frame, depth = logging.currentframe(), 2
        while frame.f_code.co_filename == logging.__file__:
            frame = frame.f_back
            depth += 1

        logger.opt(depth=depth, exception=record.exc_info).log(
            level, record.getMessage()
        )


def configure_logging() -> None:
    """
    Configure Loguru logger.

    Sets up log sinks (console, file) and intercepts standard logging.
    """
    # Create logs directory if it doesn't exist
    logs_dir = Path("logs")
    logs_dir.mkdir(exist_ok=True)

    # Configure loguru
    config = {
        "handlers": [
            {
                "sink": sys.stdout,
                "format": (
                    "<green>{time:YYYY-MM-DD HH:mm:ss.SSS}</green> | "
                    "<level>{level: <8}</level> | "
                    "<cyan>{name}</cyan>:"
                    "<cyan>{function}</cyan>:<cyan>{line}</cyan> - "
                    "<level>{message}</level>"
                ),
                "level": settings.LOG_LEVEL,
                "colorize": True,
            },
            {
                "sink": logs_dir / "ai_server.log",
                "format": (
                    "{time:YYYY-MM-DD HH:mm:ss.SSS} | "
                    "{level: <8} | "
                    "{name}:{function}:{line} - "
                    "{message}"
                ),
                "rotation": "10 MB",
                "retention": "1 week",
                "compression": "zip",
            },
        ]
    }

    # Apply config to loguru
    logger.configure(**config)

    # Intercep standard logging message
    logging.basicConfig(handlers=[IntercepHandler()], level=0, force=True)

    # Replace handlers for the modules that use standard logging
    for logger_name in logging.root.manager.loggerDict.keys():
        module_logger = logging.getLogger(logger_name)
        module_logger.propagate = False
        module_logger.handlers = [IntercepHandler()]

    logger.info("Logging configured successfully")


def get_logger(name: str):
    """Get a Loguru logger instance with the specified name."""
    return logger.bind(name=name)
