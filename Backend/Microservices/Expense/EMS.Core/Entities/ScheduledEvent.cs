using EMS.Core.Entities.Common;
using EMS.Core.Enums;

namespace EMS.Core.Entities
{
    public class ScheduledEvent : BaseAuditableEntity<int>
    {
        public string UserId { get; set; } = default!;
        public string Name { get; set; } = default!;
        public string? Description { get; set; }
        public EventType Type { get; set; }
        public string? Payload { get; set; }
        public EventStatus Status { get; set; }
        public int? RecurrenceRuleId { get; set; }

        // Timing
        public DateTimeOffset InitialTrigger { get; set; }
        public DateTimeOffset? NextOccurrence { get; set; }
        public DateTimeOffset? LastOccurrence { get; set; }

        // Navigations
        public virtual IUser<string> User { get; set; } = default!;
        public virtual RecurrenceRule? RecurrenceRule { get; set; }
        public ICollection<ScheduledEventExecution> ScheduledEventExecutions { get; set; } = [];
    }
}
