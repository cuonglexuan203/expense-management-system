using EMS.Core.Entities.Common;
using EMS.Core.Enums;

namespace EMS.Core.Entities
{
    public class ScheduledEventExecution : BaseAuditableEntity<int>
    {
        public int ScheduledEventId { get; set; }

        // Timing
        public DateTimeOffset ScheduledTime { get; set; }
        public DateTimeOffset ProcessingStartTime { get; set; }
        public DateTimeOffset? ProcessingEndTime { get; set; }
        public ExecutionStatus Status { get; set; }
        public string? Notes { get; set; } // Error details on Failure

        // Result
        public int? TransactionId { get; set; }

        // Navigations
        public ScheduledEvent ScheduledEvent { get; set; } = default!;
        public Transaction? Transaction { get; set; }
    }
}
