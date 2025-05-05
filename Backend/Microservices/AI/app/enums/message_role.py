from enum import Enum


class MessageRole(str, Enum):
    HUMAN = "Human"
    SYSTEM = "System"
