using EMS.Core.Entities;
using EMS.Core.Enums;
using Microsoft.EntityFrameworkCore.ChangeTracking;
using System.Text.Json;

namespace EMS.Application.Common.Models
{
    public class AuditEntry(EntityEntry entry)
    {
        public EntityEntry Entry { get; } = entry;
        public string UserId { get; set; } = default!;
        public AuditType Type { get; set; }
        public string EntityType { get; set; } = default!;
        public Dictionary<string, object?> OldValues { get; set; } = [];
        public Dictionary<string, object?> NewValues { get; set; } = [];
        public Dictionary<string, object> KeyValues { get; set; } = [];
        public List<string> ChangedColumns { get; set; } = [];
        public string? IpAddress { get; set; }
        public string? UserAgent { get; set; }
        public DateTimeOffset? CreatedAt { get; set; } = DateTimeOffset.UtcNow;

        public ActivityLog ToActivityLog()
        {
            var actLog = new ActivityLog();
            actLog.UserId = UserId;
            actLog.Type = Type;
            actLog.EntityType = EntityType;
            actLog.OldValues = OldValues.Count == 0 ? null : JsonSerializer.Serialize(OldValues);
            actLog.NewValues = NewValues.Count == 0 ? null : JsonSerializer.Serialize(NewValues);
            actLog.PrimaryKey = JsonSerializer.Serialize(KeyValues);
            actLog.AffectedColumns = ChangedColumns.Count == 0 ? null : JsonSerializer.Serialize(ChangedColumns);
            actLog.IpAddress = IpAddress;
            actLog.UserAgent = UserAgent;
            actLog.CreatedAt = CreatedAt;

            return actLog;
        }
    }
}
