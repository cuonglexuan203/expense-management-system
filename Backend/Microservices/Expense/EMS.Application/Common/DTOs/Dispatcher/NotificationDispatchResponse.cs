namespace EMS.Application.Common.DTOs.Dispatcher
{
    public record NotificationDispatchResponse(
        string Status,
        int? SuccessCount,
        int? FailureCount);
}
