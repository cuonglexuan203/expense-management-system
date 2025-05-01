using EMS.Application.Common.DTOs;
using EMS.Application.Common.Interfaces.DbContext;
using EMS.Application.Common.Interfaces.Services;
using EMS.Application.Features.Transactions.Commands.CreateEventTransaction;
using EMS.Core.Entities;
using EMS.Core.Enums;
using MediatR;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Logging;
using NodaTime;
using NodaTime.TimeZones;
using System.Text.Json;
using System.Text.Json.Serialization;

namespace EMS.Infrastructure.Services
{
    public class EventSchedulerService : IEventSchedulerService
    {
        private readonly ILogger<EventSchedulerService> _logger;
        private readonly IApplicationDbContext _context;
        private readonly ISender _sender;

        private static readonly Dictionary<string, IsoDayOfWeek> DayOfWeekMap = new(StringComparer.OrdinalIgnoreCase)
        {
            ["SU"]= IsoDayOfWeek.Sunday,
            ["MO"]= IsoDayOfWeek.Monday,
            ["TU"]= IsoDayOfWeek.Tuesday,
            ["WE"]= IsoDayOfWeek.Wednesday,
            ["TH"]= IsoDayOfWeek.Thursday,
            ["FR"]= IsoDayOfWeek.Friday,
            ["SA"]= IsoDayOfWeek.Saturday,
        };

        private static readonly ZoneLocalMappingResolver AmbiguityResolver = Resolvers.LenientResolver;

        public EventSchedulerService(
            ILogger<EventSchedulerService> logger,
            IApplicationDbContext context,
            ISender sender)
        {
            _logger = logger;
            _context = context;
            _sender = sender;
        }

        #region Simple implementation of CalculateNextOccurrence
        //public DateTimeOffset? CalculateNextOccurrence(ScheduledEvent scheduledEvent, DateTimeOffset lastOccurrenceAt, string timeZoneId)
        //{
        //    if (scheduledEvent.RecurrenceRule == null)
        //    {
        //        return null;
        //    }

        //    var rule = scheduledEvent.RecurrenceRule;
        //    var timeZone = DateTimeZoneProviders.Tzdb.GetZoneOrNull(timeZoneId);
        //    if (timeZone == null)
        //    {
        //        _logger.LogError("Invalid TimeZoneId '{TimeZoneId}' for ScheduledEvent {EventId}",
        //            timeZoneId,
        //            scheduledEvent.Id);

        //        return null;
        //    }

        //    if (rule.MaxOccurrences.HasValue)
        //    {
        //        int executionCount = _context.ScheduledEventExecutions
        //            .Count(e => !e.IsDeleted &&
        //                e.ScheduledEventId == scheduledEvent.Id &&
        //                e.Status == ExecutionStatus.Success);

        //        if (executionCount >= rule.MaxOccurrences.Value)
        //        {
        //            _logger.LogInformation("MaxOccurrences reached for ScheduledEvent {EventId}",
        //                scheduledEvent.Id);

        //            return null;
        //        }
        //    }

        //    // NodaTime Calculation Logic
        //    Instant lastInstant = Instant.FromDateTimeOffset(lastOccurrenceAt);
        //    ZonedDateTime lastZoned = lastInstant.InZone(timeZone);
        //    ZonedDateTime nextZoned = default!;

        //    switch (rule.Frequency)
        //    {
        //        case RecurrenceType.Daily:
        //            {
        //                nextZoned = lastZoned.Plus(Duration.FromDays(rule.Interval));
        //                break;
        //            }
        //        case RecurrenceType.Weekly:
        //            {
        //                nextZoned = lastZoned.Plus(Period.FromWeeks(rule.Interval).ToDuration());
        //                break;
        //            }
        //        case RecurrenceType.Monthly:
        //            {
        //                nextZoned = lastZoned.Plus(Period.FromMonths(rule.Interval).ToDuration());
        //                break;
        //            }
        //        case RecurrenceType.Yearly:
        //            {
        //                nextZoned = lastZoned.Plus(Period.FromYears(rule.Interval).ToDuration());
        //                break;
        //            }
        //        default:
        //            {
        //                _logger.LogError("Unsupported Frequency '{Frequency}' for ScheduledEvent {EventId}",
        //                    rule.Frequency,
        //                    scheduledEvent.Id);

        //                return null;
        //            }
        //    }

        //    DateTimeOffset nextUtc = nextZoned.ToDateTimeUtc();

        //    // Check EndDate
        //    if (rule.EndDate.HasValue && nextUtc > rule.EndDate.Value)
        //    {
        //        _logger.LogInformation("EndDate reached for ScheduledEvent {EventId}",
        //            scheduledEvent.Id);

        //        return null;
        //    }

        //    return nextUtc;
        //}
        #endregion

        public async Task<DateTimeOffset?> CalculateNextOccurrence(ScheduledEvent scheduledEvent, DateTimeOffset lastOccurrenceAt, string timeZoneId)
        {
            if (scheduledEvent.RecurrenceRule == null)
            {
                _logger.LogDebug("Event {EventId} has no recurrence rule. No next occurrence.",
                    scheduledEvent.Id);

                return null;
            }

            var rule = scheduledEvent.RecurrenceRule;
            var timeZone = DateTimeZoneProviders.Tzdb.GetZoneOrNull(timeZoneId);
            if (timeZone == null)
            {
                _logger.LogError("Invalid TimeZoneId '{TimeZoneId}' for ScheduledEvent {EventId}. Cannot calculate next occurrence.",
                    timeZoneId,
                    scheduledEvent.Id);

                return null;
            }

            Instant lastInstant = Instant.FromDateTimeOffset(lastOccurrenceAt);
            ZonedDateTime currentZoned = lastInstant.InZone(timeZone);
            ZonedDateTime candidateZoned = currentZoned;

            _logger.LogDebug("Calculating next occurrence for Event {EventId} from {LastOccurrence} ({TimeZone})",
                scheduledEvent.Id,
                currentZoned.ToString("yyyy-MM-dd HH:mm:ss o<g>", null),
                timeZoneId);

            for (int loopGuard = 0; loopGuard < 1000; loopGuard++)
            {
                candidateZoned = AdvanceByFrequency(candidateZoned, rule.Frequency, rule.Interval);
                if (candidateZoned.ToInstant() <= currentZoned.ToInstant())
                {
                    _logger.LogWarning("Advancing by frequency did not move time forward for Event {EventId}. Current: {Current}, Candidate: {Candidate}. Check rule/logic",
                        scheduledEvent.Id,
                        currentZoned,
                        candidateZoned);

                    continue;
                }

                bool skipCandidate = false;

                if (rule.Frequency == RecurrenceType.Yearly && rule.ByMonth != null && rule.ByMonth.Any())
                {
                    if (TryAdjustToNextValidMonth(candidateZoned, rule.ByMonth, currentZoned, out var adjustedCandidateZoned) 
                        && candidateZoned.ToInstant() > currentZoned.ToInstant())
                    {
                        candidateZoned = adjustedCandidateZoned;
                    }
                    else
                    {
                        skipCandidate = true;
                    }
                }

                if (!skipCandidate 
                    && (rule.Frequency == RecurrenceType.Monthly || rule.Frequency == RecurrenceType.Yearly) 
                    && rule.ByMonthDay != null && rule.ByMonthDay.Any())
                {
                    if (TryAdjustToNextValidMonthDay(candidateZoned, rule.ByMonthDay, currentZoned, out var adjustedCandidateZoned)
                        && candidateZoned.ToInstant() > currentZoned.ToInstant())
                    {
                        candidateZoned = adjustedCandidateZoned;
                    }
                    else
                    {
                        skipCandidate = true;
                    }
                }

                if (!skipCandidate && rule.ByDayOfWeek != null && rule.ByDayOfWeek.Any())
                {
                    var validDaysOfWeek = rule.ByDayOfWeek.Select(d => DayOfWeekMap.TryGetValue(d, out var day) ? day : (IsoDayOfWeek?)null)
                        .Where(d => d.HasValue)
                        .Select(d => d.Value)
                        .ToHashSet();

                    if (validDaysOfWeek.Any())
                    {
                        if (TryAdjustToNextValidDayOfWeek(candidateZoned, validDaysOfWeek, currentZoned, rule.Frequency, out var adjustedCandidateZoned)
                            && candidateZoned.ToInstant() > currentZoned.ToInstant())
                        {
                            candidateZoned = adjustedCandidateZoned;
                        }
                        else
                        {
                            skipCandidate = true;
                        }
                    }
                }

                if (skipCandidate || candidateZoned.ToInstant() <= currentZoned.ToInstant())
                {
                    _logger.LogDebug("Candidate {Candidate} skipped or invalid after BYxxx adjustments for Event {EventId}. Continuing loop.",
                        candidateZoned,
                        scheduledEvent.Id);

                    continue;
                }

                // Termination Checks
                Instant candidateInstant = candidateZoned.ToInstant();

                if (rule.EndDate.HasValue)
                {
                    var endInstant = Instant.FromDateTimeOffset(rule.EndDate.Value);
                    if (candidateInstant > endInstant)
                    {
                        _logger.LogInformation("Calculated next occurrence {Candidate} is after EndDate {EndDate} for Event {EventId}. Schedule completed.",
                            candidateZoned,
                            rule.EndDate.Value.ToString("u"),
                            scheduledEvent.Id);

                        return null;
                    }
                }

                if (rule.MaxOccurrences.HasValue)
                {
                    var executionCount = await GetExecutionCount(scheduledEvent.Id);
                    if (executionCount > rule.MaxOccurrences.Value)
                    {
                        _logger.LogInformation("MaxOccurrences ({Max}) reached or exceeded (Count: {Count}) for Event {EventId}. Schedule complete.",
                            rule.MaxOccurrences.Value,
                            executionCount,
                            scheduledEvent.Id);

                        return null;
                    }
                }

                _logger.LogInformation("Calculated next occurrence for Event {EventId}: {NextOccurrence} UTC",
                    scheduledEvent.Id,
                    candidateInstant.ToDateTimeUtc().ToString("u"));

                return candidateInstant.ToDateTimeOffset();
            }

            _logger.LogError("Failed to calculate next occurrence for Event {EventId} after multiple attempts (loop guard exceeded). Check recurrence rule complexity or potential logic error.",
                scheduledEvent.Id);

            return null;
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
                    var jsOpts = new JsonSerializerOptions ()
                    {
                        PropertyNamingPolicy = JsonNamingPolicy.CamelCase,
                        Converters = { new JsonStringEnumConverter() }
                    };
                    payload = JsonSerializer.Deserialize<FinancialEventPayload>(scheduledEvent.Payload, jsOpts)!;
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


        #region Helper methods
        private ZonedDateTime AdvanceByFrequency(ZonedDateTime current, RecurrenceType frequency, int interval)
        {
            Period period;
            switch (frequency)
            {
                case RecurrenceType.Daily:
                    {
                        period = Period.FromDays(interval);
                        break;
                    }
                case RecurrenceType.Weekly:
                    {
                        period = Period.FromWeeks(interval);
                        break;
                    }
                case RecurrenceType.Monthly:
                    {
                        period = Period.FromMonths(interval);
                        break;
                    }
                case RecurrenceType.Yearly:
                    {
                        period = Period.FromYears(interval);
                        break;
                    }
                default:
                    _logger.LogError("Unsupported Frequency '{Frequency}'. Cannot advance time.",
                        frequency);
                    return current;
            }

            return current.Plus(period.ToDuration());
        }

        private bool TryAdjustToNextValidMonth(ZonedDateTime candidate, int[] validMonths, ZonedDateTime floor, out ZonedDateTime result)
        {
            result = default;

            var monthSet = validMonths.ToHashSet();
            if (monthSet.Contains(candidate.Month))
            {
                result = candidate;
                return true;
            }

            var adjusted = candidate;
            while (true)
            {
                var currentMonth = adjusted.Month;
                int nextValidMonthInYear = monthSet.Where(m => m > currentMonth).DefaultIfEmpty(0).Min();

                int monthsToAdd;
                if (nextValidMonthInYear > 0)
                {
                    monthsToAdd = nextValidMonthInYear - currentMonth;
                }
                else
                {
                    var monthsToStartOfNextYear = 12 - currentMonth + 1;
                    var firstValidMonthNextYear = monthSet.Min();
                    monthsToAdd = monthsToStartOfNextYear + (firstValidMonthNextYear - 1);
                }

                adjusted = adjusted + Period.FromMonths(monthsToAdd).ToDuration();   

                if (monthSet.Contains(adjusted.Month) && adjusted.ToInstant() > floor.ToInstant())
                {
                    result = adjusted;
                    return true;
                }

                // NOTE: can directly return false, but it's safe to handle edge cases

                if (adjusted.Minus(candidate).TotalDays > 366 * 5)
                {
                    _logger.LogError("AdjustToNextValidMonth exceeded safety limit for Event starting from {Candidate}",
                        candidate);

                    return false;
                }
            }
        }

        private bool TryAdjustToNextValidMonthDay(ZonedDateTime candidate, int[] validDays, ZonedDateTime floor, out ZonedDateTime result)
        {
            result = default;

            var daySet = validDays.ToHashSet();

            var resolvedDaySet = new HashSet<int>();
            int daysInMonth = candidate.Calendar.GetDaysInMonth(candidate.Year, candidate.Month);

            foreach (var day in daySet)
            {
                if (day < 0)
                {
                    var resolvedDay = daysInMonth + day + 1;
                    if (resolvedDay >= 1)
                    {
                        resolvedDaySet.Add(resolvedDay);
                    }
                }
                else if (day <= daysInMonth)
                {
                    resolvedDaySet.Add(day);
                }
            }

            if (!resolvedDaySet.Any())
            {
                //var startOfNextMonth = new LocalDateTime(
                //    candidate.Year + (candidate.Month == 12 ? 1 : 0),
                //    candidate.Month == 12 ? 1 : candidate.Month + 1,
                //    1, candidate.Hour, candidate.Minute, candidate.Second);

                var startOfNextMonth = candidate.LocalDateTime
                    .PlusMonths(1)
                    .With(DateAdjusters.StartOfMonth);

                result = candidate.Zone.ResolveLocal(startOfNextMonth, AmbiguityResolver);
                return true;
            }

            if (resolvedDaySet.Contains(candidate.Day))
            {
                result = candidate;
                return true;
            }

            int nextDayInMonth = resolvedDaySet.Where(d => d > candidate.Day).DefaultIfEmpty(0).Min();
            if (nextDayInMonth > 0)
            {
                var targetLtd = candidate.LocalDateTime.PlusDays(nextDayInMonth - candidate.Day);

                result = candidate.Zone.ResolveLocal(targetLtd, AmbiguityResolver);
                return true;
            }

            // Advance to the next month
            var nextMonthCandidate = candidate;
            while (true)
            {
                var startOfNextMonthLdt = nextMonthCandidate.LocalDateTime
                    .PlusMonths(1)
                    .With(DateAdjusters.StartOfMonth);

                nextMonthCandidate = nextMonthCandidate.Zone.ResolveLocal(startOfNextMonthLdt, AmbiguityResolver);

                if (nextMonthCandidate.ToInstant() <= floor.ToInstant())
                {
                    continue;
                }

                var daysInNextMonth = nextMonthCandidate.Calendar.GetDaysInMonth(nextMonthCandidate.Year, nextMonthCandidate.Month);
                resolvedDaySet.Clear();
                foreach (var day in daySet)
                {
                    if (day < 0)
                    {
                        var resolvedDay = daysInNextMonth + day + 1;
                        if (resolvedDay >= 1)
                        {
                            resolvedDaySet.Add(resolvedDay);
                        }
                    }
                    else if(day <= daysInNextMonth)
                    {
                        resolvedDaySet.Add(day);
                    }
                }

                if (!resolvedDaySet.Any())
                {
                    continue;
                }

                var firstDayNextMonth = resolvedDaySet.Min();

                var targetLdt = nextMonthCandidate.LocalDateTime.PlusDays(firstDayNextMonth - 1);

                result = nextMonthCandidate.Zone.ResolveLocal(targetLdt, AmbiguityResolver);
                return true;
            }
        }

        private bool TryAdjustToNextValidDayOfWeek(
            ZonedDateTime candidate,
            HashSet<IsoDayOfWeek> validDays,
            ZonedDateTime floor,
            RecurrenceType frequency,
            out ZonedDateTime result)
        {
            result = default;

            if (validDays.Contains(candidate.DayOfWeek))
            {
                result = candidate;
                return true;
            }

            var adjusted = candidate;
            int daysChecked = 0;
            int maxDaysToCheck = frequency switch
            {
                RecurrenceType.Weekly => 8,
                RecurrenceType.Monthly => 32,
                RecurrenceType.Yearly => 367,
                _ => 367
            };

            while (daysChecked < maxDaysToCheck)
            {
                adjusted = adjusted.Plus(Period.FromDays(1).ToDuration());
                daysChecked++;

                if (validDays.Contains(adjusted.DayOfWeek) && adjusted.ToInstant() > floor.ToInstant())
                {
                    result = adjusted;
                    return true;
                }
            }

            _logger.LogWarning("Could not find next valid DayOfWeek within reasonable bounds for date {Candidate}",
                candidate);

            return false;
        }

        private async Task<int> GetExecutionCount(int scheduledEventId)
        {
            try
            {
                return await _context.ScheduledEventExecutions
                    .CountAsync(e => !e.IsDeleted &&
                        e.ScheduledEventId == scheduledEventId &&
                        e.Status == ExecutionStatus.Success);
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Failed to query execution count for event {EventId}",
                    scheduledEventId);

                return 0;
            }
        }
        #endregion
    }
}
