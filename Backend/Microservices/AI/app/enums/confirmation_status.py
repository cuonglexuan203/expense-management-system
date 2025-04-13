from enum import Enum


class ConfirmationStatus(str, Enum):
    Confirmed = "Confirmed"
    Rejected = "Rejected"
