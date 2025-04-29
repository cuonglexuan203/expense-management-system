using EMS.Core.Entities;

namespace EMS.Application.Common.Interfaces.Services
{
    public interface IEventSchedulerService
    {
        DateTimeOffset? CalculateNextOccurrence(ScheduledEvent scheduledEvent, DateTimeOffset lastOccurrenceAt, string timeZoneId);
        Task<ScheduledEventExecution> TriggerEventAsync(ScheduledEvent scheduledEvent, CancellationToken cancellationToken = default);
    }
}
