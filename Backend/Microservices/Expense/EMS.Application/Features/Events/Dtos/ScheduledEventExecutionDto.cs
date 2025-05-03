using EMS.Application.Common.Mappings;
using EMS.Core.Entities;
using EMS.Core.Enums;

namespace EMS.Application.Features.Events.Dtos
{
    public class ScheduledEventExecutionDto : IMapFrom<ScheduledEventExecution>
    {
        public int Id { get; set; }
        public int ScheduledEventId { get; set; }
        public DateTimeOffset ScheduledTime { get; set; }
        public DateTimeOffset ProcessingStartTime { get; set; }
        public DateTimeOffset? ProcessingEndTime { get; set; }
        public ExecutionStatus Status { get; set; }
        public string? Notes { get; set; }
        public int? TransactionId { get; set; }
        public DateTimeOffset? CreatedAt { get; set; }
    }
}
