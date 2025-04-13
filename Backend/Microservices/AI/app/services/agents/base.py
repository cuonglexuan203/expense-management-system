from abc import ABC, abstractmethod
from typing import Any, List, Optional
from langchain.schema.language_model import BaseLanguageModel
from app.schemas import LLMConfig
from app.services.llm.factory import LLMFactory
from langgraph.graph.graph import CompiledGraph


class BaseAgent(ABC):
    """Base class for all agents in the system."""

    def __init__(
        self,
        llm_config: LLMConfig,
        tools: Optional[List[Any]] = None,
    ):
        """
        Initialize the base agent.

        Args:
            llm_config: Configuration for the LLM
            tools: Optional list of tools for the agent
        """
        self.llm_config = llm_config
        self.tools = tools or []

        # Initialize the LLM
        self.model = self._initialize_llm()

        self.react_agent = self._create_react_agent()

    def _initialize_llm(self) -> BaseLanguageModel:
        """Initialize the LLM based on the configuration."""
        return LLMFactory.create(self.llm_config)

    @abstractmethod
    def _create_react_agent(self) -> CompiledGraph:
        """
        Create the react agent.

        Returns:
            React agent instance
        """
        pass

    def get_agent(self) -> CompiledGraph:
        return self.react_agent
