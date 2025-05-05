namespace EMS.API.Common.Models.AiToolController
{
    public record GetEventOccurrencesRequest(
        DateTimeOffset FromUtc,
        DateTimeOffset ToUtc);
}
