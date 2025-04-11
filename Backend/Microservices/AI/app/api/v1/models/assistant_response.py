from typing import Any
from pydantic import BaseModel, Field
from app.services.agents import FinancialAgent, EventAgent
from app.services.agents.responses.event_response import EventResponse
from app.services.agents.responses.financial_response import FinancialResponse
from langchain_core.messages import BaseMessage


class AssitantResponse(BaseModel):
    llm_content: str | None = Field(
        default=None, description="LLM-based assistant message"
    )
    type: str | None = Field(default=None, description="Response type (human/tool/ai)")
    name: str | None = Field(default=None, description="Agent or message source name")
    financial_response: FinancialResponse | None = Field(
        default=None, description="Financial agent response"
    )
    event_response: EventResponse | None = Field(
        default=None, description="Event agent response"
    )

    @classmethod
    def create_from_agent_response(cls, response: dict[str, Any]):
        init_data = {}

        messages = response.get("messages")

        if isinstance(messages, list) and messages:
            agent_msg: BaseMessage = messages[-1]
            init_data["llm_content"] = agent_msg.content
            init_data["type"] = agent_msg.type
            init_data["name"] = agent_msg.name

        structured_response_data = response.get("structured_response")
        name = init_data.get("name")

        if structured_response_data is not None:
            if name == FinancialAgent.name:
                init_data["financial_response"] = structured_response_data
            elif name == EventAgent.name:
                init_data["event_response"] = structured_response_data

        return cls(**init_data)
