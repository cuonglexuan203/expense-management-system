using EMS.Application.Common.Mappings;
using EMS.Core.Entities;
using EMS.Core.Enums;

namespace EMS.Application.Features.Notifications.Dtos
{
    public class NotificationDto : IMapFrom<Notification>
    {
        public int Id { get; set; }
        public string UserId { get; set; } = default!;
        public NotificationType Type { get; set; }
        public string Title { get; set; } = default!;
        public string Body { get; set; } = default!;
        //public string? DataPayload { get; set; }
        public NotificationStatus Status { get; set; }
        public DateTimeOffset? ProcessedAt { get; set; }
        public DateTimeOffset? CreatedAt { get; set; }
    }
}
