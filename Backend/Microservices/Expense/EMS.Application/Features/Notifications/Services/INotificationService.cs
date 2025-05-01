using EMS.Core.Entities;
using EMS.Core.Enums;

namespace EMS.Application.Features.Notifications.Services
{
    public interface INotificationService
    {
        Task PushEventNotificationAsync(string userId, ScheduledEvent scheduledEvent, ScheduledEventExecution executionLog, CancellationToken cancellationToken = default);
    }
}
