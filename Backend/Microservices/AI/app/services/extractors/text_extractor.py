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
You are an expert financial query analyzer AI. Your task is to analyze the user's text message about expense/income transactions:

Analyze the user's text query to extract all financial transactions. For each transaction, identify the following:

- Name: Description of the item or transaction (as mentioned by the user).
- Category: Applicable category (from the provided available categories, omit if no match).
- Type: 'Expense' or 'Income' (infer from context).
- Amount: Monetary value (extract if present).
- Currency: Currency code (infer from context or default to '{default_currency}').
- Occurred At: Date and time of the transaction (infer from context, default to '{today}' and current time if not specified, ISO format).

Useful information:
- Today: {today}
- User's language: {language}
- User's available categories: {categories}
- User's preferences: {preferences}
- Default Currency: {default_currency}

IMPORTANT - Currency Slang Information for {currency_code}:
{currency_slangs}

User Query: {query}

Steps to follow:
1. Identify all items in the query that represent financial transactions.
2. Categorize each item appropriately using the provided available categories.
3. Determine the transaction type ("Expense" or "Income") for each item based on the context.
4. Extract the monetary amount and identify the currency (using slang information if necessary).
5. Determine the date and time of the transaction. If not explicitly mentioned, use today's date ({today}) and the current time, ISO format.
6. Generate a funny and friendly introduction text about the identified transactions, using the user's language '{language}'.

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
                "language": preferences.language_code or "English",
                "categories": ", ".join(categories),
                "preferences": preferences,
                "default_currency": "USD",
                "currency_code": preferences.currency_code,
                "currency_slangs": currency_slang,
                "query": user_message,
            }
        )

        return result
