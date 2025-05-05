from datetime import datetime
from typing import Optional, List
from pydantic import BaseModel, Field

from app.enums.recurrence_type import RecurrenceType


class RecurrenceRule(BaseModel):
    """Recurrence rule for scheduling tasks.
    Follows iCalendar specification.
    """

    frequency: RecurrenceType = Field(
        description="Frequency of recurrence. MUST be one of: 'Daily', 'Weekly', 'Monthly', 'Yearly'.",
    )
    interval: Optional[int] = Field(
        default=1,
        description="Interval of the frequency (e.g., 2 for every 2 weeks). Defaults to 1.",
    )
    by_day_of_week: Optional[List[str]] = Field(
        default=None,
        description="List of ISO days ('MO', 'TU', 'WE', 'TH', 'FR', 'SA', 'SU'). Used for Weekly, Monthly, Yearly.",
    )
    by_month_day: Optional[List[int]] = Field(
        default=None,
        description="List of days of the month (1-31) or negative indices (-1 for last, -2 for second last). Used for Monthly, Yearly.",
    )
    by_month: Optional[List[int]] = Field(
        default=None, description="List of months (1-12). Used for Yearly."
    )
    end_date: Optional[datetime] = Field(
        default=None, description="The UTC datetime after which the recurrence stops."
    )
    max_occurrences: Optional[int] = Field(
        default=None, description="Maximum number of times the event should occur."
    )
