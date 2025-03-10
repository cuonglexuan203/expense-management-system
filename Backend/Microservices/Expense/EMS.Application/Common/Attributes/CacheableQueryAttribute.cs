using EMS.Application.Common.Utils;

namespace EMS.Application.Common.Attributes
{
    [AttributeUsage(AttributeTargets.Class, AllowMultiple = false)]
    public class CacheableQueryAttribute : Attribute
    {
        public string KeyPrefix { get; } = default!;
        public int ExpirationMinutes { get; }

        public CacheableQueryAttribute(string keyPrefix, int expirationMinutes = 30)
        {
            KeyPrefix = keyPrefix;
            ExpirationMinutes = expirationMinutes;
        }

        public virtual string GenerateCacheKey(object request)
        {
            var properties = request.GetType().GetProperties();
            var parameters = new object[properties.Length];

            for(int i = 0; i < properties.Length; i++)
            {
                parameters[i] = properties[i].GetValue(request, null) ?? "null";
            }

            return CacheKeyGenerator.Generate(KeyPrefix, parameters);
        }
    }
}
