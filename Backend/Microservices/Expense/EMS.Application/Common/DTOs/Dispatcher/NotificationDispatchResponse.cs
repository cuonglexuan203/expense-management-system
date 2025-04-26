namespace EMS.Application.Common.DTOs.Dispatcher
{
    public record NotificationDispatchResponse(
        string Message,
        NotificationDispatchResponseData Data);

    public record NotificationDispatchResponseData(
        string Status,
        int? SuccessCount,
        int? FailureCount);
}
