using EMS.Core.Common.Interfaces;
using EMS.Core.Common.Interfaces.Audit;
using EMS.Core.Enums;

namespace EMS.Core.Entities
{
    public class ActivityLog : IIdentifiable<int>, ICreated
    {
        public int Id { get; set; }
        public Guid UserId { get; set; }
        public AuditType Type { get; set; }
        public string EntityType { get; set; } = default!;
        public string? OldValues { get; set; }
        public string? NewValues { get; set; }
        public string PrimaryKey { get; set; } = default!;
        public string? AffectedColumns { get; set; }
        public string? IpAddress { get; set; }
        public string? UserAgent { get; set; }
        public string? Metadata { get; set; }
        public DateTimeOffset? CreatedAt { get; set; }
        public Guid? CreatedBy { get; set; }
    }
}
