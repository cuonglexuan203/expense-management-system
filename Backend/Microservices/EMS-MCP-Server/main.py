from fastapi.routing import Mount
from app.core import settings
from app.core.lifespan import lifespan
from fastapi.middleware.cors import CORSMiddleware
from fastapi import FastAPI
from app.api.v1.router import api_router
from app.mcp.ems_server import mcp_router, sse


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
    application.include_router(mcp_router, tags=["MCP"])

    return application


def mount_sse_server(app: FastAPI) -> FastAPI:
    app.router.routes.append(Mount("/messages", app=sse.handle_post_message))

    return app


app = mount_sse_server(create_application())


@app.get("/")
async def root():
    return {"message": "Welcome to the EMS MCP Service"}


if __name__ == "__main__":
    import uvicorn

    uvicorn.run(
        "main:app",
        host=settings.SERVER_HOST,
        port=settings.SERVER_PORT,
        reload=settings.DEBUG_MODE,
        log_level=settings.LOG_LEVEL.lower(),
    )
