from enum import Enum


class EventStatus(Enum):
    ACTIVE = "Active"
    QUEUED = "Queued"
    PROCESSING = "Processing"
    PAUSED = "Paused"
    COMPLETED = "Completed"
    ERROR = "Error"
