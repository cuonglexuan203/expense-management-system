using EMS.Core.Enums;

namespace EMS.Application.Features.Events.Dtos
{
    public class EventOccurrenceDto
    {
        public Guid Id { get; set; } = Guid.NewGuid();
        public int ScheduledEventId { get; set; }
        public string Name { get; set; } = default!;
        public string? Description { get; set; }
        public DateTimeOffset ScheduledTime { get; set; }
        public EventType EventType { get; set; }
        public string? Payload { get; set; }
        public bool IsRecurring { get; set; } = false;
        public EventStatus ScheduledEventStatus { get; set; }
        public ScheduledEventExecutionDto? ExecutionLog { get; set; }
        public RecurrenceRuleDto? RecurrenceRule { get; set; }

        public static EventOccurrenceDto CreateFrom(
            ScheduledEventDto scheduledEvent,
            DateTimeOffset startAt,
            ScheduledEventExecutionDto? executionLog = default)
        {
            var eventOccDto = new EventOccurrenceDto
            {
                ScheduledEventId = scheduledEvent.Id,
                Name = scheduledEvent.Name,
                Description = scheduledEvent.Description,
                ScheduledTime = startAt,
                EventType = scheduledEvent.Type,
                Payload = scheduledEvent.Payload,
                IsRecurring = scheduledEvent.RecurrenceRuleId != null,
                ScheduledEventStatus = scheduledEvent.Status,
                ExecutionLog = executionLog,
                RecurrenceRule = scheduledEvent.RecurrenceRule,
            };

            return eventOccDto;
        }
    }
}
