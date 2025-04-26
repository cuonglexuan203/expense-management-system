using EMS.Core.Entities.Common;
using EMS.Core.Enums;

namespace EMS.Core.Entities
{
    public class Notification : BaseAuditableEntity<int>
    {
        public string UserId { get; set; } = default!;
        public NotificationType Type { get; set; }
        public string Title { get; set; } = default!;
        public string Body { get; set; } = default!;
        public string? DataPayload { get; set; }
        public NotificationStatus Status { get; set; }
        // OPTIMIZE: additional properties SourceEntityId, SourceEntityType ('Goal', 'Transaction')
        public DateTimeOffset? ProcessedAt { get; set; }

        // Navigations
        public virtual IUser<string> User { get; set; } = default!;
        public ICollection<ExtractedTransaction> ExtractedTransactions { get; set; } = [];
    }
}
