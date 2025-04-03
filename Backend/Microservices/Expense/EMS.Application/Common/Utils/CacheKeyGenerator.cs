namespace EMS.Application.Common.Utils
{
    public static class CacheKeyGenerator
    {
        public static string Generate(string prefix, params object[] parameters)
        {
            return $"{prefix}:{string.Join(":", parameters)}";
        }

        public static string GenerateForUser(string prefix, string userId, params object[] parameters)
        {
            return Generate(prefix, [userId, .. parameters]);
        }

        public static class QueryKeys
        {
            public const string WalletByUser = "wallet_by_user";
        }

        public static class GeneralKeys
        {
            public const string UnknownCategory = "unknown_category";
            public const string DefaultCategory = "default_category";
            public const string UserPreference = "user_preference";
        }
    }
}
