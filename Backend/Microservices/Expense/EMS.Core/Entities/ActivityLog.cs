using EMS.Core.Entities.Common;
using EMS.Core.Enums;

namespace EMS.Core.Entities
{
    public class ActivityLog : BaseEntity<int>
    {
        public string? UserId { get; set; } // NOTE: can be user id or api key id (AI service)
        public AuditType Type { get; set; }
        public string EntityType { get; set; } = default!;
        public string? OldValues { get; set; }
        public string? NewValues { get; set; }
        public string PrimaryKey { get; set; } = default!;
        public string? AffectedColumns { get; set; }
        public string? IpAddress { get; set; }
        public string? UserAgent { get; set; }
        public DateTimeOffset? CreatedAt { get; set; }
    }
}
