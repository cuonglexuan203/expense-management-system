using EMS.Core.Entities.Common;
using EMS.Core.Enums;

namespace EMS.Core.Entities
{
    public class NotificationPreference: BaseEntity<int>
    {
        public Guid UserId { get; set; }
        public NotificationType Type { get; set; }
        public bool IsEnabled { get; set; }
        public NotificationChannel Channel { get; set; } = NotificationChannel.Push;
    }
}
