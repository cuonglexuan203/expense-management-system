using EMS.Application.Common.Utils;

namespace EMS.Application.Common.Attributes
{
    [AttributeUsage(AttributeTargets.Class, AllowMultiple = true)]
    public class UserInvalidateCacheAttribute : InvalidateCacheAttribute
    {
        public string? UserId { get; set; }

        public UserInvalidateCacheAttribute(string keyPrefix) : base(keyPrefix)
        {
            
        }

        public UserInvalidateCacheAttribute(string keyPrefix, string userId) : base(keyPrefix)
        {
            UserId = UserId;
        }

        public string GetUserKeyPrefix()
        {
            return CacheKeyGenerator.GenerateForUser(KeyPrefix, UserId ?? "null");
        }
    }
}
