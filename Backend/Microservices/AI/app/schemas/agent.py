from typing import Optional, Dict, Any, Literal
from pydantic import BaseModel, Field


class AgentConfig(BaseModel):
    """
    Configuration for agent behavior and execution settings.
    """

    verbose: bool = Field(
        default=False,
        description="Whether to enable verbose output during agent execution",
    )

    max_iterations: int = Field(
        default=10, ge=1, description="Maximum number of iterations the agent can take"
    )

    early_stopping_method: Literal["force", "generate"] = Field(
        default="force",
        description=(
            "Method to use for early stopping. 'force' stops at max_iterations, "
            "'generate' allows the agent to decide to stop"
        ),
    )

    timeout: Optional[float] = Field(
        default=None,
        description="Timeout in seconds for the agent execution. None means no timeout.",
    )

    return_intermediate_steps: bool = Field(
        default=False,
        description="Whether to return intermediate steps in the agent's response",
    )

    handle_parsing_errors: bool = Field(
        default=True, description="Whether to handle parsing errors gracefully"
    )

    additional_settings: Dict[str, Any] = Field(
        default_factory=dict, description="Additional agent-specific settings"
    )

    class Config:
        """Pydantic config."""

        extra = "forbid"  # Forbid extra attributes
        json_schema_extra = {
            "examples": [
                {
                    "verbose": True,
                    "max_iterations": 15,
                    "early_stopping_method": "generate",
                    "timeout": 30.0,
                    "return_intermediate_steps": True,
                    "handle_parsing_errors": True,
                    "additional_settings": {"use_history": True},
                }
            ]
        }
