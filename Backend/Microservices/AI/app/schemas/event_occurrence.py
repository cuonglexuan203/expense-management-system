from datetime import datetime
from typing import Optional
from uuid import UUID, uuid4
from pydantic import BaseModel, Field

from app.enums.event_status import EventStatus
from app.enums.event_type import EventType
from app.schemas.recurrence_rule import RecurrenceRule
from app.schemas.scheduled_event_execution import ScheduledEventExecution


class EventOccurrence(BaseModel):
    """
    Represents a single, specific instance or occurrence of a scheduled event,
    which might be part of a recurring series.
    """

    id: UUID = Field(
        default_factory=uuid4,
        description="The unique identifier for this specific event occurrence instance. Generated automatically if not provided.",
    )
    scheduled_event_id: int = Field(
        description="The identifier of the parent scheduled event definition to which this occurrence belongs."
    )
    name: str = Field(
        description="The name of the event for this specific occurrence (e.g., 'Monthly Rent Payment', 'Alice's Birthday'). \
Often inherited from the parent event."
    )
    description: Optional[str] = Field(
        default=None,
        description="An optional description providing more details about this specific event occurrence.",
    )
    scheduled_time: datetime = Field(
        description="The exact date and time (timezone-aware) when this specific event occurrence is scheduled to happen or be processed."
    )
    event_type: EventType = Field(
        description="The type or category of the event (e.g., FINANCE, REMINDER). MUST be one of available values."
    )
    payload: Optional[str] = Field(
        default=None,
        description="Optional data payload associated with this event occurrence, often used for processing logic \
(e.g., transaction details in JSON format, notification content).",
    )
    is_recurring: bool = Field(
        default=False,
        description="Flag indicating whether this event occurrence is part of a recurring series defined by the parent ScheduledEvent.",
    )
    scheduled_event_status: EventStatus = Field(
        description="The current status of this specific event occurrence (e.g., ACTIVE, QUEUED, PROCESSING, PAUSED, COMPLETED, ERROR). \
MUST be one of available values."
    )
    execution_log: Optional[ScheduledEventExecution] = Field(
        default=None,
        description="Optional details about the actual execution attempt for this scheduled occurrence, \
including processing times, status, and any resulting transaction ID. Null if not yet executed or logged.",
    )
    recurrence_rule: Optional[RecurrenceRule] = Field(
        default=None,
        description="The recurrence rule (e.g., RRULE string or structured object), follows iCalendar specification, that generated this occurrence, \
if it's part of a recurring series. Often defined on the parent ScheduledEvent, may be included here for context.",
    )
