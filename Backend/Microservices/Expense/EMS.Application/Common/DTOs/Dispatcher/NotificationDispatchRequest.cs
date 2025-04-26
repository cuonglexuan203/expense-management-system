namespace EMS.Application.Common.DTOs.Dispatcher
{
    public record NotificationDispatchRequest(
        string UserId,
        string Title,
        string Body,
        Dictionary<string, string>? Data = null);
}
