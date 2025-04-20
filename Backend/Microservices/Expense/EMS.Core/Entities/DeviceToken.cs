using EMS.Core.Entities.Common;
using EMS.Core.Enums;

namespace EMS.Core.Entities
{
    public class DeviceToken : BaseAuditableEntity<int>
    {
        public string UserId { get; set; } = default!;
        public string Token { get; set; } = default!; // Registration token (FCM)
        public Platform? Platform { get; set; }
        public DateTimeOffset? LastUsedAt { get; set; }
        public bool IsActive { get; set; }

        #region Behaviors
        public static DeviceToken Create(
            string userId,
            string token,
            Platform? platform = null,
            bool isActive = true)
        {
            return new()
            {
                UserId = userId,
                Token = token,
                Platform = platform,
                LastUsedAt = DateTimeOffset.UtcNow,
                IsActive = isActive,
            };
        }
        #endregion
    }
}
