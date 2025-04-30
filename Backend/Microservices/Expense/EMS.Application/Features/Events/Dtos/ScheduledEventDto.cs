using EMS.Application.Common.Mappings;
using EMS.Core.Entities;
using EMS.Core.Enums;

namespace EMS.Application.Features.Events.Dtos
{
    public class ScheduledEventDto : IMapFrom<ScheduledEvent>
    {
        public int Id { get; set; }
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

        public DateTimeOffset? CreatedAt { get; set; }

        public RecurrenceRuleDto? RecurrenceRule { get; set; }
    }
}
