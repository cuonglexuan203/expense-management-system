import uvicorn
from app.core import settings, lifespan
from fastapi.middleware.cors import CORSMiddleware
from fastapi import FastAPI
from app.api.v1.router import api_router


def create_application() -> FastAPI:
    """
    Factory function that creates and configures the FastAPI application
    """
    application = FastAPI(
        title=settings.PROJECT_NAME,
        description=settings.PROJECT_DESCRIPTION,
        version=settings.VERSION,
        docs_url="/docs",
        redoc_url="/redoc",
        lifespan=lifespan,
    )

    # Configure CORS
    application.add_middleware(
        CORSMiddleware,
        allow_origins=settings.ALLOWED_HOSTS,
        allow_credentials=True,
        allow_methods=["*"],
        allow_headers=["*"],
    )

    # Add API routers
    application.include_router(api_router, prefix=settings.API_V1_STR)

    # Register event handlers
    # application.add_event_handler("startup", startup_event_handler(application))
    # application.add_event_handler("shutdown", shutdown_event_handler(application))

    return application


app = create_application()


@app.get("/")
async def root():
    return {"message": "Welcome to the Expense Management AI Service"}


if __name__ == "__main__":
    uvicorn.run(
        "main:app",
        host=settings.SERVER_HOST,
        port=settings.SERVER_PORT,
        reload=settings.DEBUG_MODE,
        log_level=settings.LOG_LEVEL.lower(),
    )
