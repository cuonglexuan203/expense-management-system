using EMS.Application.Features.Events.Dtos;
using EMS.Core.Enums;

namespace EMS.API.Common.Models.AiToolController
{
    public record ScheduleEventRequest(
        string Name,
        string? Description,
        EventType Type,
        string? Payload,
        DateTimeOffset InitialTriggerDateTime,
        RecurrenceRuleRequest? Rule);
}
