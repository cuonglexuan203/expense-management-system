from app.core.config import settings


class BackendEndpoints:
    BASE_URL = f"{settings.BACKEND_BASE_URL}"

    CATEGORIES = "/api/v1/categories"

    USER_PREFERENCES = "/api/v1/users/{user_id}/preferences"

    CURRENCY_SLANGS = "/api/v1/currency-slangs/{currency_code}"

    TRANSACTIONS = "/api/v1/ai-tools/users/{user_id}/transactions"

    MESSAGES = "/api/v1/ai-tools/users/{user_id}/chat-threads/{chat_thread_id}/messages"

    WALLETS = "/api/v1/ai-tools/users/{user_id}/wallets"

    WALLET_BY_ID = "/api/v1/ai-tools/users/{user_id}/wallets/{wallet_id}"

    EXTRACTED_TRANSACTIONS_STATUS = (
        "/api/v1/ai-tools/users/{user_id}/extracted-transactions/status"
    )
