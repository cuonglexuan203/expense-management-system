﻿using EMS.Application.Common.Utils;

namespace EMS.Application.Common.Attributes
{
    [AttributeUsage(AttributeTargets.Class, AllowMultiple = false)]
    public class UserCacheableQueryAttribute : CacheableQueryAttribute
    {
        public string UserId { get; set; } = default!;
        public UserCacheableQueryAttribute(string keyPrefix, int expirationMinutes = 30)
            : base(keyPrefix, expirationMinutes)
        {

        }

        public UserCacheableQueryAttribute(string keyPrefix, string userId, int expirationMinutes = 30)
            : base(keyPrefix, expirationMinutes)
        {
            UserId = userId;
        }

        public override string GenerateCacheKey(object request)
        {
            var properties = request.GetType().GetProperties();
            var parameters = new object[properties.Length];

            for (int i = 0; i < properties.Length; i++)
            {
                parameters[i] = properties[i].GetValue(request, null) ?? "null";
            }

            return CacheKeyGenerator.GenerateForUser(KeyPrefix, UserId, parameters);
        }
    }
}
