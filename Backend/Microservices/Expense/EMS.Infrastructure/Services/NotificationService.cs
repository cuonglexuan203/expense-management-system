﻿using EMS.Application.Common.Interfaces.DbContext;
using EMS.Application.Common.Interfaces.Services.HttpClients;
using EMS.Application.Features.Notifications.Services;
using EMS.Core.Entities;
using EMS.Core.Enums;
using Microsoft.Extensions.Logging;
using System.Text.Json;

namespace EMS.Infrastructure.Services
{
    public class NotificationService : INotificationService
    {
        private readonly ILogger<NotificationService> _logger;
        private readonly IDispatcherService _dispatcher;
        private readonly IApplicationDbContext _context;

        public NotificationService(
            ILogger<NotificationService> logger,
            IDispatcherService dispatcher,
            IApplicationDbContext context)
        {
            _logger = logger;
            _dispatcher = dispatcher;
            _context = context;
        }
        public async Task PushEventNotificationAsync(string userId, ScheduledEvent scheduledEvent, ScheduledEventExecution executionLog, CancellationToken cancellationToken = default)
        {
            try
            {
                var (title, body) = GetEventNotification(scheduledEvent, executionLog);

                var notification = new Notification
                {
                    UserId = userId,
                    Type = NotificationType.EventReminder,
                    Title = title,
                    Body = body,
                    Status = NotificationStatus.Processing,
                };

                _context.Notifications.Add(notification);
                await _context.SaveChangesAsync();

                var customData = new Dictionary<string, string>()
                {
                    ["notification_id"] = notification.Id.ToString(),
                    ["type"] = notification.Type.ToString(),
                    ["status"] = notification.Status.ToString(),
                };

                notification.DataPayload = JsonSerializer.Serialize(customData);
                await _context.SaveChangesAsync();

                try
                {
                    var pushResult = await _dispatcher.SendNotification(new(
                        notification.UserId,
                        notification.Title,
                        notification.Body,
                        customData));

                    if (pushResult != null)
                    {
                        _logger.LogInformation("Push Event Notification completed: {Status}, {SuccessCount} succeeded, {FailureCount} failed",
                            pushResult.Data.Status,
                            pushResult.Data.SuccessCount,
                            pushResult.Data.FailureCount);
                    }
                    else
                    {
                        _logger.LogInformation("Push Event Notification completed.");
                    }
                }
                catch (HttpRequestException httpEx)
                {
                    _logger.LogError("An HTTP request error occurred while sending event notification to dispatcher: {ErrorMsg}",
                        httpEx.Message);

                    throw;
                }
            }
            catch (Exception ex)
            {
                _logger.LogError("An error occurred while sending push notification for Event {EventId}: {ErrorMsg}",
                    scheduledEvent.Id,
                    ex.Message);
            }
        }

        private (string Title, string Body) GetEventNotification(ScheduledEvent scheduledEvent, ScheduledEventExecution executionLog)
        {
            switch (scheduledEvent.Type)
            {
                case EventType.Finance:
                    {
                        return ($"Finance Reminder: {scheduledEvent.Name}",
                            $"Your financial event \"{scheduledEvent.Name}\" is approaching." +
                            (!string.IsNullOrEmpty(scheduledEvent.Description) ? $" Note: {scheduledEvent.Description}" : ""));
                    }
                case EventType.Reminder:
                    {
                        return ($"Reminder: {scheduledEvent.Name}",
                            $"Don't forget: \"{scheduledEvent.Name}\" is scheduled soon." +
                            (!string.IsNullOrEmpty(scheduledEvent.Description) ? $" Details: {scheduledEvent.Description}" : ""));
                    }
                default:
                    return ($"Reminder: {scheduledEvent.Name}", 
                        $"Event: {scheduledEvent.Name}." +
                        (!string.IsNullOrEmpty(scheduledEvent.Description) ? $" Details: {scheduledEvent.Description}" : ""));
            }
        }
    }
}
