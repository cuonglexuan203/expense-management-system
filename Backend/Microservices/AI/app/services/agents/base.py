from abc import ABC, abstractmethod
from typing import Any, List, Optional
from langchain.schema.language_model import BaseLanguageModel
from langchain.memory import ConversationBufferMemory
from langchain.agents import AgentExecutor
from app.schemas import AgentConfig, LLMConfig
from app.services.llm.factory import LLMFactory


class BaseAgent(ABC):
    """Base class for all agents in the system."""

    def __init__(
        self,
        llm_config: LLMConfig,
        agent_config: Optional[AgentConfig] = None,
        memory: Optional[Any] = None,
        tools: Optional[List[Any]] = None,
    ):
        """
        Initialize the base agent.

        Args:
            llm_config: Configuration for the LLM
            agent_config: Optional configuration for the agent
            memory: Optional memory instance for the agent
            tools: Optional list of tools for the agent
        """
        self.llm_config = llm_config
        self.agent_config = agent_config or AgentConfig()
        self.memory = memory or self._create_default_memory()
        self.tools = tools or []

        # Initialize the LLM
        self.llm = self._initialize_llm()

        self.agent_executor = self._create_agent_executor()

    def _initialize_llm(self) -> BaseLanguageModel:
        """Initialize the LLM based on the configuration."""
        return LLMFactory.create(self.llm_config)

    def _create_default_memory(self):
        """Create a default memory instance."""
        return ConversationBufferMemory(memory_key="chat_history", return_messages=True)

    @abstractmethod
    def _create_agent_executor(self) -> AgentExecutor:
        """
        Create the agent executor.

        Returns:
            AgentExecutor instance
        """
        pass

    @abstractmethod
    def run(self, *args, **kwargs) -> Any:
        """
        Run the agent with the provided inputs.

        Returns:
            Agent execution result
        """
        pass

    def add_tool(self, tool: Any) -> None:
        """
        Add a tool to the agent's toolset.

        Args:
            tool: Tool instance to add
        """
        self.tools.append(tool)

        # Recreate the agent executor with the updated tools
        self.agent_executor = self._create_agent_executor()

    def remove_tool(self, tool_name: str) -> bool:
        """
        Remove a tool from the agent's toolset by name.

        Args:
            tool_name: Name of the tool to remove

        Returns:
            True if the tool was removed, False otherwise
        """
        original_length = len(self.tools)
        self.tools = [tool for tool in self.tools if tool.name != tool_name]

        if len(self.tools) < original_length:
            self.agent_executor = self._create_agent_executor()
            return True

        return False

    def clear_memory(self) -> None:
        "Clear the agent's memory"
        self.memory.clear()
