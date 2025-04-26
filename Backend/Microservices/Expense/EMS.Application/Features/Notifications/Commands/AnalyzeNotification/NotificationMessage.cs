namespace EMS.Application.Features.Notifications.Commands.AnalyzeNotification
{
    public class NotificationMessage
    {
        public string UserId { get; set; } = default!;
        public string AppName { get; set; } = default!;
        public string Title { get; set; } = default!;
        public string? Content { get; set; }
        public Dictionary<string, object>? Metadata { get; set; }
        public DateTimeOffset CreatedAt { get; set; }
    }
}
