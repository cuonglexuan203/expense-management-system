import hashlib
import json


class CacheKeyGenerator:

    @staticmethod
    def generate_key(prefix: str, *args, **kwargs) -> str:
        key_dict = kwargs

        if args:
            key_dict |= {"args": args}

        key_json = json.dumps(key_dict, sort_keys=True)
        key_hash = hashlib.sha512(key_json.encode()).hexdigest()

        return f"{prefix}:{key_hash}"

    class GeneralKeys:
        CATEGORY: str = "category"
        USER_PREFERENCES: str = "user_preferences"
