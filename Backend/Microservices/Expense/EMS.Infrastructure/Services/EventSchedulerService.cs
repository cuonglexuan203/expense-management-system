using EMS.Application.Common.DTOs;
using EMS.Application.Common.Interfaces.DbContext;
using EMS.Application.Common.Interfaces.Services;
using EMS.Application.Features.Transactions.Commands.CreateEventTransaction;
using EMS.Core.Entities;
using EMS.Core.Enums;
using MediatR;
using Microsoft.Extensions.Logging;
using NodaTime;
using System;
using System.Text.Json;
using System.Text.Json.Serialization;

namespace EMS.Infrastructure.Services
{
    public class EventSchedulerService : IEventSchedulerService
    {
        private readonly ILogger<EventSchedulerService> _logger;
        private readonly IApplicationDbContext _context;
        private readonly IUserPreferenceService _userPreferenceService;
        private readonly ISender _sender;

        public EventSchedulerService(
            ILogger<EventSchedulerService> logger,
            IApplicationDbContext context,
            IUserPreferenceService userPreferenceService,
            ISender sender)
        {
            _logger = logger;
            _context = context;
            _userPreferenceService = userPreferenceService;
            _sender = sender;
        }
        public DateTimeOffset? CalculateNextOccurrence(ScheduledEvent scheduledEvent, DateTimeOffset lastOccurrenceAt, string timeZoneId)
        {
            if (scheduledEvent.RecurrenceRule == null)
            {
                return null;
            }

            var rule = scheduledEvent.RecurrenceRule;
            var timeZone = DateTimeZoneProviders.Tzdb.GetZoneOrNull(timeZoneId);
            if (timeZone == null)
            {
                _logger.LogError("Invalid TimeZoneId '{TimeZoneId}' for ScheduledEvent {EventId}",
                    timeZoneId,
                    scheduledEvent.Id);

                return null;
            }

            if (rule.MaxOccurrences.HasValue)
            {
                int executionCount = _context.ScheduledEventExecutions
                    .Count(e => !e.IsDeleted &&
                        e.ScheduledEventId == scheduledEvent.Id &&
                        e.Status == ExecutionStatus.Success);

                if (executionCount >= rule.MaxOccurrences.Value)
                {
                    _logger.LogInformation("MaxOccurrences reached for ScheduledEvent {EventId}",
                        scheduledEvent.Id);

                    return null;
                }
            }

            // NodaTime Calculation Logic
            Instant lastInstant = Instant.FromDateTimeOffset(lastOccurrenceAt);
            ZonedDateTime lastZoned = lastInstant.InZone(timeZone);
            ZonedDateTime nextZoned = default!;

            switch (rule.Frequency)
            {
                case RecurrenceType.Daily:
                    {
                        nextZoned = lastZoned.Plus(Duration.FromDays(rule.Interval));
                        break;
                    }
                case RecurrenceType.Weekly:
                    {
                        nextZoned = lastZoned.Plus(Period.FromWeeks(rule.Interval).ToDuration());
                        break;
                    }
                case RecurrenceType.Monthly:
                    {
                        nextZoned = lastZoned.Plus(Period.FromMonths(rule.Interval).ToDuration());
                        break;
                    }
                case RecurrenceType.Yearly:
                    {
                        nextZoned = lastZoned.Plus(Period.FromYears(rule.Interval).ToDuration());
                        break;
                    }
                default:
                    {
                        _logger.LogError("Unsupported Frequency '{Frequency}' for ScheduledEvent {EventId}",
                            rule.Frequency,
                            scheduledEvent.Id);

                        return null;
                    }
            }

            DateTimeOffset nextUtc = nextZoned.ToDateTimeUtc();

            // Check EndDate
            if (rule.EndDate.HasValue && nextUtc > rule.EndDate.Value)
            {
                _logger.LogInformation("EndDate reached for ScheduledEvent {EventId}",
                    scheduledEvent.Id);

                return null;
            }

            return nextUtc;
        }

        // NOTE: this trigger method only create and modify the scheduled event execution log, please keep the scheduled event intact 
        public async Task<ScheduledEventExecution> TriggerEventAsync(ScheduledEvent scheduledEvent, CancellationToken cancellationToken = default)
        {
            var executionLog = new ScheduledEventExecution
            {
                ScheduledEventId = scheduledEvent.Id,
                ScheduledTime = scheduledEvent.NextOccurrence ?? DateTimeOffset.UtcNow,
                ProcessingStartTime = DateTimeOffset.UtcNow,
            };

            try
            {
                switch (scheduledEvent.Type)
                {
                    case EventType.Finance:
                        {
                            await ProcessFinancialEventAsync(scheduledEvent, executionLog, cancellationToken);
                            break;
                        }
                }
            }
            catch (Exception ex)
            {
                executionLog.Status = ExecutionStatus.Failure;
                executionLog.Notes = ex.Message;
                _logger.LogError("Trigger event {ScheduledEventId} failed. Error: {ErrorMsg}",
                    scheduledEvent.Id, ex.Message);
                scheduledEvent.Status = EventStatus.Error;
            }

            executionLog.ProcessingEndTime = DateTimeOffset.UtcNow;

            return executionLog;
        }

        private async Task ProcessFinancialEventAsync(ScheduledEvent scheduledEvent, ScheduledEventExecution executionLog, CancellationToken cancellationToken = default)
        {
            try
            {
                if(string.IsNullOrEmpty(scheduledEvent.Payload))
                {
                    _logger.LogError("Could not process the financial event with empty payload: ID {ScheduledEventId}",
                        scheduledEvent.Id);

                    throw new InvalidOperationException("The scheduled event payload is empty.");
                }

                FinancialEventPayload payload = default!;
                try
                {
                    var a = new JsonSerializerOptions ()
                    {
                        PropertyNamingPolicy = JsonNamingPolicy.CamelCase,
                        Converters = { new JsonStringEnumConverter() }
                    };
                    payload = JsonSerializer.Deserialize<FinancialEventPayload>(scheduledEvent.Payload, a)!;
                }
                catch (JsonException jsonEx)
                {
                    _logger.LogError("Could not deserialize the financial event payload: {ErrorMsg}", jsonEx.Message);

                    throw;
                }

                var transactionDto = await _sender.Send(new CreateEventTransactionCommand(
                    scheduledEvent.UserId,
                    scheduledEvent.Name,
                    payload.WalletId,
                    payload.CategoryId,
                    payload.Amount,
                    payload.Type,
                    DateTimeOffset.UtcNow));

                executionLog.Status = ExecutionStatus.Success;
                executionLog.TransactionId = transactionDto.Id;
            }
            catch (Exception ex)
            {
                _logger.LogError("Failed to process the financial event {EventId}: {ErrorMsg}", scheduledEvent.Id, ex.Message);

                throw;
            }
        }
    }
}
