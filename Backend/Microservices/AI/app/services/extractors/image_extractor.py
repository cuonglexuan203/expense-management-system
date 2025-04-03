import datetime
from app.api.v1.models.user_preferences import UserPreferences
from app.core.logging import get_logger
from app.services.extractors.base import BaseExtractor
from app.services.llm.output_parsers.transaction_analysis_output import (
    TransactionAnalysisOutput,
)
from app.services.llm.output_parsers import transaction_parser
from langchain_core.prompts import (
    ChatPromptTemplate,
    SystemMessagePromptTemplate,
    HumanMessagePromptTemplate,
)

logger = get_logger(__name__)


SYSTEM_MESSAGE = """
You are an expert financial query analyzer AI. Your task is to analyze the user's message about expense/income transactions:

Analyze both the user's text query and any provided image (receipt/bill) to extract all financial transactions.

**From the Image (if provided):**
Carefully analyze the image and extract all transactions visible in the receipt/bill.
For each transaction include:
- Name: Item name (as on receipt).
- Category: Applicable category (if matches available categories, otherwise omit).
- Type: 'Expense' or 'Income' (exactly).
- Amount: Monetary value.
- Currency: Currency code (default '{default_currency}' if not specified).
- Occurred At: Date and time from receipt (use receipt date and current time if time missing, ISO format).

**From the User's Text Query:**
Identify all explicit and implicit financial transactions mentioned in the user's message. For each transaction include:
- Name: Description of the transaction (as mentioned by the user).
- Category: Applicable category (if matches available categories, otherwise omit).
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

Steps to follow:
1. Analyze the user's text query for transaction details.
2. Analyze the provided image (if any) for transaction details from the receipt/bill.
3. Combine the extracted transactions from both sources.
4. Categorize each transaction appropriately using the available categories.
5. Determine the transaction type ("Expense" or "Income") for each item.
6. Be aware of currency slang terms in the user's country and convert them correctly.
7. Provide a funny and friendly introduction text about the identified transactions, using the user's language '{language}'.

{format_instructions}
"""


class ImageExtractor(BaseExtractor):
    """Extract transactions from text and image input."""

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

        image_urls: list[str] = input_data.get("image_urls", [])
        image_contents = self.__get_image_contents__(image_urls)

        today = datetime.datetime.now(datetime.timezone.utc)

        model = self.create_llm()
        parser = transaction_parser

        messages = [
            SystemMessagePromptTemplate.from_template(
                template=SYSTEM_MESSAGE,
                partial_variables={
                    "format_instructions": parser.get_format_instructions()
                },
            ),
            HumanMessagePromptTemplate.from_template(
                template=[{"type": "text", "text": user_message}, *image_contents],
            ),
        ]

        prompt = ChatPromptTemplate(messages)

        # formatted_prompt = prompt.format_prompt(
        #     **{
        #         "today": today,
        #         "language": preferences.language or "English",
        #         "categories": ", ".join(categories),
        #         "preferences": preferences,
        #         "default_currency": "USD",
        #         "currency_code": preferences.currency_code,
        #         "currency_slangs": currency_slang,
        #     }
        # ).to_string()

        # print(formatted_prompt)

        chain = prompt | model | parser

        result = await chain.ainvoke(
            {
                "today": today,
                "language": preferences.language or "English",
                "categories": ", ".join(categories),
                "preferences": preferences,
                "default_currency": "USD",
                "currency_code": preferences.currency_code,
                "currency_slangs": currency_slang,
            }
        )

        return result

    @staticmethod
    def __get_image_contents__(image_urls: list[str]):
        return [
            {"type": "image_url", "image_url": {"url": image_url}}
            for image_url in image_urls
        ]
