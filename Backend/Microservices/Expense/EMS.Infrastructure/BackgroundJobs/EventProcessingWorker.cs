using EMS.Application.Common.Interfaces.Messaging;
using EMS.Application.Common.Interfaces.Services;
using EMS.Core.Enums;
using EMS.Infrastructure.Common.Options;
using EMS.Infrastructure.Persistence.DbContext;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.Hosting;
using Microsoft.Extensions.Logging;
using Microsoft.Extensions.Options;
using System.Text.Json;
using System.Text.Json.Serialization;

namespace EMS.Infrastructure.BackgroundJobs
{
    public class EventProcessingWorker : BackgroundService
    {
        private readonly ILogger<EventProcessingWorker> _logger;
        private readonly IServiceScopeFactory _scopeFactory;
        private readonly IMessageQueueService _mqService;
        private readonly RedisOptions _redisOpts;
        private readonly JsonSerializerOptions _serializerOptions;

        public EventProcessingWorker(
            ILogger<EventProcessingWorker> logger,
            IServiceScopeFactory scopeFactory,
            IMessageQueueService mqService,
            IOptions<RedisOptions> options)
        {
            _logger = logger;
            _scopeFactory = scopeFactory;
            _mqService = mqService;
            _redisOpts = options.Value;
            _serializerOptions = new()
            {
                PropertyNamingPolicy = JsonNamingPolicy.SnakeCaseLower,
                Converters = { new JsonStringEnumConverter() }
            };
        }

        protected override async Task ExecuteAsync(CancellationToken stoppingToken)
        {
            _logger.LogInformation("Event Processing Worker starting...");

            while (!stoppingToken.IsCancellationRequested)
            {
                try
                {
                    var value = await _mqService.DequeueAsync<EventProcessingPayload>(
                        _redisOpts.MessageQueues.EventProcessingQueueName,
                        null,
                        true,
                        _serializerOptions);

                    if (value != null)
                    {
                        await ProcessEventAsync(value.ScheduledEventId, stoppingToken);
                    }
                    else
                    {
                        await Task.Delay(TimeSpan.FromSeconds(5), stoppingToken);
                    }
                }
                catch (OperationCanceledException)
                {
                    _logger.LogInformation("Event Processing Worker is stopping...");
                    break;
                }
                catch (Exception ex)
                {
                    _logger.LogError(ex, "An error occurred in the event processing worker loop. Waiting before retry...");

                    await Task.Delay(TimeSpan.FromSeconds(5), stoppingToken);
                }
            }

            _logger.LogInformation("Event Processing Worker stopped.");
        }

        private async Task ProcessEventAsync(int scheduledEventId, CancellationToken stoppingToken)
        {
            _logger.LogInformation("Processing scheduled event: ID {EventId}", scheduledEventId);

            using var scope = _scopeFactory.CreateScope();
            var sp = scope.ServiceProvider;
            var context = sp.GetRequiredService<ApplicationDbContext>();
            var eventSchedulerService = sp.GetRequiredService<IEventSchedulerService>();
            var userPreferenceService = sp.GetRequiredService<IUserPreferenceService>();

            var strategy = context.Database.CreateExecutionStrategy();
            await strategy.ExecuteAsync(async () =>
            {
                await using var dbTransaction = await context.Database.BeginTransactionAsync(stoppingToken);
                try
                {
                    var scheduledEvent = await context.ScheduledEvents
                        .Include(e => e.RecurrenceRule)
                        .FirstOrDefaultAsync(e => !e.IsDeleted && e.Id == scheduledEventId, stoppingToken);

                    if (scheduledEvent == null)
                    {
                        _logger.LogError("ScheduledEvent {ScheduledEventId} not found.", scheduledEventId);

                        await dbTransaction.RollbackAsync(stoppingToken);
                        return;
                    }

                    if (scheduledEvent.Status != EventStatus.Queued)
                    {
                        _logger.LogWarning("ScheduledEvent {ScheduledEventId} is in unexpected status '{Status}'. Skipping",
                            scheduledEventId, scheduledEvent.Status);

                        await dbTransaction.RollbackAsync(stoppingToken);
                        return;
                    }

                    scheduledEvent.Status = EventStatus.Processing;
                    await context.SaveChangesAsync(stoppingToken);

                    // Log execution
                    var executionLog = await eventSchedulerService.TriggerEventAsync(scheduledEvent, stoppingToken);
                    context.ScheduledEventExecutions.Add(executionLog);

                    if (executionLog.Status == ExecutionStatus.Success)
                    {
                        _logger.LogInformation("Event {ScheduledEventId} processed successfully.",
                            scheduledEvent.Id);

                        var userPreference = await userPreferenceService.GetUserPreferenceByUserIdAsync(scheduledEvent.UserId);

                        DateTimeOffset? nextOccurrence = eventSchedulerService.CalculateNextOccurrence(
                            scheduledEvent,
                            scheduledEvent.NextOccurrence!.Value,
                            userPreference.TimeZoneId!);

                        scheduledEvent.LastOccurrence = scheduledEvent.NextOccurrence;
                        scheduledEvent.NextOccurrence = nextOccurrence;

                        if (nextOccurrence.HasValue)
                        {
                            scheduledEvent.Status = EventStatus.Active;
                        }
                        else
                        {
                            scheduledEvent.Status = EventStatus.Completed;
                            _logger.LogInformation("ScheduledEvent {ScheduledEventId} marked as COMPLETED.",
                                scheduledEvent.Id);
                        }
                    }
                    else
                    {
                        _logger.LogError("Event {ScheduledEventId} processing failed. Notes: {Notes}",
                            scheduledEventId, executionLog.Notes);

                        scheduledEvent.Status = EventStatus.Error;
                    }

                    await context.SaveChangesAsync(stoppingToken);

                    await dbTransaction.CommitAsync(stoppingToken);
                }
                catch (Exception ex)
                {
                    _logger.LogError(ex, "An error occurred during processing of ScheduledEvent {ScheduledEventId}. Rolling back transaction.",
                        scheduledEventId);

                    try
                    {
                        await dbTransaction.RollbackAsync(CancellationToken.None);
                    }
                    catch (Exception rollbackEx)
                    {
                        _logger.LogError(
                            rollbackEx,
                            "Failed to rollback transaction for event {ScheduledEventId}",
                            scheduledEventId);
                    }

                    // TODO: implement retry mechanism or dead-letter queue, or lost if not handled.
                    // BUG: temporarily accept lost
                }
            });
        }

        internal class EventProcessingPayload
        {
            public int ScheduledEventId { get; set; }
        }
    }
}
