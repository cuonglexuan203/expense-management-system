from app.core.config import settings


class BackendEndpoints:
    BASE_URL = f"{settings.BACKEND_BASE_URL}"

    CATEGORIES = "/api/v1/categories"

    USER_PREFERENCES = "/api/v1/users/{user_id}/preferences"

    CURRENCY_SLANGS = "/api/v1/currency-slangs/{currency_code}"
