from datetime import datetime
from typing import Optional
from pydantic import BaseModel

from app.schemas.recurrence_rule import RecurrenceRule


class ScheduledEvent(BaseModel):
    id: int
    user_id: str
    name: str
    description: Optional[str] = None
    type: str
    payload: Optional[str] = None
    status: str
    recurrence_rule_id: Optional[int] = (
        None
    )

    # Timing
    initial_trigger: datetime
    next_occurrence: Optional[datetime] = None
    last_occurrence: Optional[datetime] = None

    created_at: Optional[datetime] = None

    recurrence_rule: Optional[RecurrenceRule] = None
