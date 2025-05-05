using EMS.Core.Entities;

namespace EMS.Application.Common.Interfaces.Services
{
    public interface IEventSchedulerService
    {
        Task<DateTimeOffset?> CalculateNextOccurrenceAsync(ScheduledEvent scheduledEvent, DateTimeOffset lastOccurrenceAt, string timeZoneId);

        Task<List<DateTimeOffset>> CalculateOccurrencesAsync(ScheduledEvent scheduledEvent, DateTimeOffset startingPoint, DateTimeOffset endPoint, string timeZoneId);

        Task<ScheduledEventExecution> TriggerEventAsync(ScheduledEvent scheduledEvent, CancellationToken cancellationToken = default);
    }
}
