import datetime
from app.api.v1.models.user_preferences import UserPreferences
from app.core.logging import get_logger
from app.services.extractors.base import BaseExtractor
from app.services.llm.output_parsers.transaction_analysis_output import (
    TransactionAnalysisOutput,
)
from langchain_core.prompts import PromptTemplate
from app.services.llm.output_parsers import transaction_parser

logger = get_logger(__name__)

TEXT_EXTRACTION_PROMPT = """
You are an expert financial query analyzer AI. Your task is to analyze the user's message about expense/income transactions:

1. Identify all Expense/Income items
2. Categorize each transaction (e.g.: travel, entertainment, health, salary, ...), do not refer in output if do not match any
3. Determine transaction type (Expense/Income) for each item
4. Extract amounts and currencies
5. Extract the occurred time (use today if not specified: {today})
6. Generate a concise introduction text, this text should be funny and friendly

User's language: {language}
User's available categories: {categories}
User's preferences: {preferences}
Default Currency: {default_currency}

IMPORTANT - Currency Slang Information for {currency_code}:
{currency_slangs}

User Query: {query}

Steps to follow:
1. Identify all items in the query that represent financial transactions.
2. Categorize each item appropriately.
3. Determine the transaction type: "Expense" or "Income" for each item.
4. Be aware of currency slang terms in the user's country and convert them correctly.
5. Provide an interesting introduction text about the transactions.

Note: Make sure to use the user's language {language} to answer.

{format_instructions}
"""


class TextExtractor(BaseExtractor):
    """Extractor for text-based transaction extraction."""

    async def extract(self, user_id, input_data) -> TransactionAnalysisOutput:
        user_message = input_data.get("message", "")

        if not user_message:
            logger.warning("Empty message received")
            return TransactionAnalysisOutput(
                transactions=[], introduction="No message provided"
            )

        categories: list[str] = input_data.get("categories", [])
        preferences: UserPreferences = input_data.get("user_preferences", {})
        currency_slang = await self.backend_client.get_currency_slang(
            preferences.currency_code
        )

        model = self.create_llm()
        parser = transaction_parser

        prompt = PromptTemplate(
            template=TEXT_EXTRACTION_PROMPT,
            input_variables=[
                "today",
                "language",
                "categories",
                "preferences",
                "default_currency",
                "country_code",
                "currency_slangs",
                "query",
            ],
            partial_variables={"format_instructions": parser.get_format_instructions()},
        )

        # formatted_prompt = prompt.format_prompt(
        #     **{
        #         "today": "2025",
        #         "language": preferences.language or "English",
        #         "categories": ", ".join(categories),
        #         "preferences": preferences,
        #         "default_currency": "USD",
        #         "currency_code": preferences.currency_code,
        #         "currency_slangs": currency_slang,
        #         "query": user_message,
        #     }
        # )

        # print(formatted_prompt.to_string())

        chain = prompt | model | parser

        today = datetime.datetime.now(datetime.timezone.utc)

        result = await chain.ainvoke(
            {
                "today": today,
                "language": preferences.language or "English",
                "categories": ", ".join(categories),
                "preferences": preferences,
                "default_currency": "USD",
                "currency_code": preferences.currency_code,
                "currency_slangs": currency_slang,
                "query": user_message,
            }
        )

        return result
