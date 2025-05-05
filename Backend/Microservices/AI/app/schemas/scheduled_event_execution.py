from datetime import datetime
from typing import Optional
from pydantic import BaseModel, Field

from app.enums.execution_status import ExecutionStatus


class ScheduledEventExecution(BaseModel):
    """
    Represents the execution details of a scheduled event instance.
    """

    id: int = Field(
        description="The unique identifier for this specific execution record."
    )
    scheduled_event_id: int = Field(
        description="The identifier of the parent scheduled event definition to which this execution belongs."
    )
    scheduled_time: datetime = Field(
        description="The exact date and time (timezone-aware) when this event instance was scheduled to be executed."
    )
    processing_start_time: datetime = Field(
        description="The exact date and time (timezone-aware) when the system began processing this scheduled event instance."
    )
    processing_end_time: Optional[datetime] = Field(
        default=None,
        description="The exact date and time (timezone-aware) when the system finished processing this instance. \
Null if processing is ongoing, failed before completion, or hasn't started.",
    )
    status: ExecutionStatus = Field(
        description="The current status of this specific scheduled event execution. Must be one of the available values."
    )
    notes: Optional[str] = Field(
        default=None,
        description="Optional text field for storing any relevant notes, logs, or error messages related to this execution instance.",
    )
    transaction_id: Optional[int] = Field(
        default=None,
        description="The identifier of the financial transaction record created as a result of this event execution, \
if applicable (e.g., for a recurring bill payment).",
    )
    created_at: Optional[datetime] = Field(
        default=None,
        description="The timestamp (timezone-aware) indicating when this execution record was first created in the system. \
May be null if not tracked or before initial save.",
    )
