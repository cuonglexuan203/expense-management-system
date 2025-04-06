from mcp.server.fastmcp import FastMCP
from fastapi import APIRouter, Request
from mcp.server.sse import SseServerTransport

# from app.core.config import settings

# ems_mcp = FastMCP(settings.MCP_SERVER_NAME)
ems_mcp = FastMCP("EMS MCP Server")


mcp_router = APIRouter()

sse = SseServerTransport("/messages/")


@mcp_router.get("/health")
def health():
    return {"status": "ok"}


@mcp_router.get("/config")
def config():
    return {}


@mcp_router.get("/messages")
async def handle_messages(request: Request, include_in_schema=True):
    """
    Messages endpoint for SSE communication

    This endpoint is used for posting messages to SSE clients.
    Note: This route is for documentation purposes only.
    The actual implementation is handled by the SSE transport.
    """
    # await sse.handle_post_message(request.scope, request.receive, request._send)
    pass


@mcp_router.get("/sse")
async def handle_sse(request: Request):
    """
    SSE endpoint that connects to the MCP server

    This endpoint establishes a Server-Sent Events connection with the client
    and forwards communication to the Model Context Protocol server.
    """
    async with sse.connect_sse(request.scope, request.receive, request._send) as (
        read_stream,
        write_stream,
    ):
        await ems_mcp._mcp_server.run(
            read_stream,
            write_stream,
            ems_mcp._mcp_server.create_initialization_options(),
        )


if __name__ == "__main__":
    # ems_mcp.run(transport="sse")
    ems_mcp.run_sse_async()
