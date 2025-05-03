using EMS.Application.Features.Events.Dtos;

namespace EMS.API.Common.Models.EventController
{
    public record UpdateEventRequest(
        string? Name,
        string? Description,
        string? Payload,
        DateTimeOffset? InitialTriggerDateTime,
        RecurrenceRuleRequest? Rule);
}
