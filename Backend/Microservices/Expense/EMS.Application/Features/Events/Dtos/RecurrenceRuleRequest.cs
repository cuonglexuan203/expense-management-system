using EMS.Core.Enums;

namespace EMS.Application.Features.Events.Dtos
{
    public record RecurrenceRuleRequest(
        RecurrenceType Frequency,
        int? Interval,
        string[]? ByDayOfWeek,
        int[]? ByMonthDay,
        int[]? ByMonth,
        DateTimeOffset? EndDate,
        int? MaxOccurrences);
}
