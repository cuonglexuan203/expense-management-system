from enum import Enum


class MessageRole(str, Enum):
    User = "User"
    System = "System"
