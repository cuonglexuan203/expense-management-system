from typing import Any, Dict, List, Optional
from app.core.logging import get_logger
from app.schemas.agent import AgentConfig
from app.schemas.llm_config import LLMConfig
from app.services.agents import BaseAgent
from app.services.llm.output_parsers import (
    transaction_parser,
    TransactionAnalysisOutput,
)
from langchain_core.prompts import PromptTemplate
from langchain.agents import create_react_agent, AgentExecutor
from app.services.agents.prompts import TRANSACTION_PROMPT

logger = get_logger(__name__)


class TransactionAnalyzerAgent(BaseAgent):
    def __init__(
        self,
        llm_config: LLMConfig,
        agent_config: Optional[AgentConfig] = None,
        memory: Optional[Any] = None,
        tools: Optional[List[Any]] = None,
    ):
        self.format_instructions = transaction_parser.get_format_instructions()
        self.output_parser = transaction_parser
        super().__init__(llm_config=llm_config)

    def _create_agent_executor(self):
        """Create the React agent executor for intent analysis."""

        prompt = PromptTemplate(
            template=TRANSACTION_PROMPT,
            partial_variables={"format_instructions": self.format_instructions},
        )

        agent = create_react_agent(llm=self.llm, tools=self.tools, prompt=prompt)

        return AgentExecutor(
            agent=agent,
            tools=self.tools,
            memory=self.memory,
            verbose=self.agent_config.verbose,
            # handle_parsing_errors=True,
            # max_iterations=self.agent_config.max_iterations,
            # early_stopping_method=self.agent_config.early_stopping_method,
        )

    async def run(self, query: str) -> TransactionAnalysisOutput:
        result = await self.agent_executor.ainvoke({"input": query})

        try:
            parsed_output = self.output_parser.parse(result["output"])
            return parsed_output
        except Exception as e:
            logger.error(f"Error: {str(e)}...")
            if isinstance(result["output"], dict):
                return TransactionAnalysisOutput(**result["output"])
            else:
                return TransactionAnalysisOutput(
                    transactions=[],
                    transaction_type="unknown",
                    introduction="Analysis could not be completed.",
                    total_expenses=0,
                    total_income=0,
                )

    async def analyze_transaction(self, query: str) -> Dict[str, Any]:
        result = await self.run(query)
        return result.dict()
