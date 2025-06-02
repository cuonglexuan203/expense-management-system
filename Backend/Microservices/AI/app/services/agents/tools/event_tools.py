from datetime import datetime, timedelta
from typing import Any, Dict, Optional
from langchain_core.tools import tool
from app.core.logging import get_logger
from app.enums.event_type import EventType
from app.schemas.event_occurrence import EventOccurrence
from app.schemas.scheduled_event import ScheduledEvent
from app.services.backend import backend_client
from app.schemas.recurrence_rule import RecurrenceRule
from langchain_core.runnables import RunnableConfig
from langgraph.prebuilt import InjectedState
from typing import Annotated

logger = get_logger(__name__)


@tool
async def schedule_event(
    name: str,
    type: EventType,
    initialTriggerDateTime: datetime,
    description: Optional[str],
    payload: Optional[Dict[str, Any]],
    rule: Optional[RecurrenceRule],
    state: Annotated[dict, InjectedState],
    config: RunnableConfig,
) -> ScheduledEvent:
    """Schedules a new one-time or recurring event based on user request.

    Use this tool to create reminders or schedule future/recurring financial transactions (expenses/income).
    You MUST ask the user for clarification if any required information is missing before calling this tool.

    Args:
        name (str): REQUIRED. A user-defined name for the event (e.g., 'Rent Payment', 'Mom's Birthday Reminder').
        type (EventType): REQUIRED. The category of the event. Must be exactly 'Finance' (for events involving money) \
or 'Reminder' (for notification-only events).
        initialTriggerDateTime (datetime): REQUIRED. The *first* date and time the event should occur. \
This MUST be provided as a timezone-aware datetime object representing the exact moment in **UTC**.
        description (Optional[str]): An optional longer description for the event. Defaults to None.
        payload (Optional[Dict[str, Any]]): REQUIRED if `type` is 'Finance', otherwise MUST be None. A dictionary containing financial details. \
If 'Finance', it MUST contain: 'type' (string: 'Expense' or 'Income'), 'amount' (number), 'walletId' (integer or string UUID). \
It can optionally contain 'categoryId' (integer or string UUID). Example for Finance: `{'type': 'Expense', 'amount': 150.75, 'walletId': 1, 'categoryId': 20}`.
        rule (Optional[RecurrenceRule]): REQUIRED if the event repeats (is recurring), otherwise MUST be None. Defines the recurrence pattern. Contains fields:
            - frequency (str): REQUIRED. 'Daily', 'Weekly', 'Monthly', or 'Yearly'.
            - interval (Optional[int]): Defaults to 1.
            - by_day_of_week (Optional[List[str]]): e.g., ['MO', 'FR'].
            - by_month_day (Optional[List[int]]): e.g., [1, 15, -1].
            - by_month (Optional[List[int]]): e.g., [1, 7].
            - end_date (Optional[datetime]): The recurrence end date/time in UTC.
            - max_occurrences (Optional[int]): Max number of occurrences.

    Returns:
        ScheduledEvent: An object representing the newly scheduled event, confirming the operation. \
Includes the event ID and potentially the next calculated occurrence time.
    """

    user_id = (
        config["configurable"].get("user_id")
        if config and "configurable" in config
        else None
    )

    if not user_id:
        user_id = state["user_id"]

    if not user_id:
        logger.error("Error: user_id not found in config.")
        raise ValueError("User ID not found, cannot schedule event.")

    # --- Input Validation (Crucial for Robustness) ---
    if type == "Finance" and payload is None:
        raise ValueError("Payload is required when event type is 'Finance'.")
    if type == "Finance":
        if not all(k in payload for k in ("type", "amount", "walletId")):
            raise ValueError(
                "Finance payload must contain 'type', 'amount', and 'walletId'."
            )
        if payload["type"] not in ["Expense", "Income"]:
            raise ValueError("Finance payload 'type' must be 'Expense' or 'Income'.")
    # if type == "Reminder" and payload is not None:
    #     raise ValueError("Payload must be None when event type is 'Reminder'.")
    if rule is not None and not hasattr(rule, "frequency"):
        raise ValueError("Invalid 'rule' object provided for recurring event.")

    # Ensure datetime is UTC (NodaTime handles this better, but basic check here)
    if initialTriggerDateTime.tzinfo is None or initialTriggerDateTime.tzinfo.utcoffset(
        initialTriggerDateTime
    ) != timedelta(0):
        logger.warning(
            f"initialTriggerDateTime provided might not be UTC: {initialTriggerDateTime}. Attempting to treat as UTC."
        )
        # initialTriggerDateTime = initialTriggerDateTime.replace(tzinfo=timezone.utc) # Example fix, use carefully

    # --- Call Backend Client ---
    try:
        is_recurring = rule is not None
        actual_rule = rule if is_recurring else None

        scheduled_event = await backend_client.schedule_event(
            user_id=user_id,
            name=name,
            description=description,
            type=type,
            payload=payload,
            initialTriggerDateTime=initialTriggerDateTime,
            rule=actual_rule,
        )
        return scheduled_event
    except Exception as e:
        logger.error(f"Error calling backend to schedule event: {e}")
        # raise e # Option 1: Let the agent framework handle the exception
        return ScheduledEvent(id="ERROR", name=f"Backend Error: {e}")


@tool
async def get_event_occurrences(
    fromUtc: datetime,
    toUtc: datetime,
    config: RunnableConfig,
) -> list[EventOccurrence]:
    """Retrieves all specific occurrences (instances) of scheduled events that fall within a given UTC date/time range.

    Use this tool when the user asks to see their schedule, calendar, upcoming bills, reminders, or events between two specific dates or for a specific period \
(e.g., "next week", "in May", "between April 1st and April 15th").

    Args:
        fromUtc (datetime): REQUIRED. The start date and time of the range to query. \
This MUST be provided as a timezone-aware datetime object representing the exact moment in **UTC**.
        toUtc (datetime): REQUIRED. The end date and time of the range to query. \
This MUST be provided as a timezone-aware datetime object representing the exact moment in **UTC**.

    Returns:
        List[EventOccurrence]: A list of EventOccurrence objects. Each object represents a single instance of an event occurring within the specified \
`fromUtc` to `toUtc` range. The list will be empty if no occurrences fall within the range. \
Each occurrence includes details like its specific scheduled time (in UTC), name, type, payload (if any), and the ID of the parent scheduled event rule.
    """
    # Extract user_id from the config
    user_id = (
        config["configurable"].get("user_id")
        if config and "configurable" in config
        else None
    )
    if not user_id:
        logger.error("Error: user_id not found in config.")
        raise ValueError("User ID not found, cannot retrieve event occurrences.")

    # --- Basic Input Validation ---
    if fromUtc.tzinfo is None or fromUtc.tzinfo.utcoffset(fromUtc) != timedelta(0):
        logger.warning(
            f"fromUtc provided might not be UTC: {fromUtc}. Backend expects UTC."
        )
        # Consider raising error or attempting conversion if necessary, based on strictness
        # fromUtc = fromUtc.replace(tzinfo=timezone.utc)
    if toUtc.tzinfo is None or toUtc.tzinfo.utcoffset(toUtc) != timedelta(0):
        logger.warning(
            f"toUtc provided might not be UTC: {toUtc}. Backend expects UTC."
        )
        # toUtc = toUtc.replace(tzinfo=timezone.utc)
    if fromUtc >= toUtc:
        raise ValueError("fromUtc must be earlier than toUtc.")

    # --- Call Backend Client ---
    try:
        # The backend client method simulates the actual API call logic provided
        # It correctly formats the datetimes as ISO strings for the query parameters
        occurrences = await backend_client.get_event_occurrences(
            user_id=user_id,
            fromUtc=fromUtc,
            toUtc=toUtc,
        )
        return occurrences
    except Exception as e:
        logger.error(f"Error calling backend to get event occurrences: {e}")
        # Depending on desired agent behavior, re-raise or return empty list/error indicator
        # raise e
        return []
