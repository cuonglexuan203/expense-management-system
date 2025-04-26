using EMS.Application.Common.Mappings;
using EMS.Core.Entities;
using EMS.Core.Enums;

namespace EMS.Application.Features.DeviceTokens.Dtos
{
    public class DeviceTokenDto : IMapFrom<DeviceToken>
    {
        public string UserId { get; set; } = default!;
        public string Token { get; set; } = default!; // Registration token (FCM)
        public Platform? Platform { get; set; }
        public DateTimeOffset? LastUsedAt { get; set; }
        public bool IsActive { get; set; }
        public DateTimeOffset? CreatedAt { get; set; }
    }
}
