namespace EMS.Infrastructure.Services.HttpClients.DispatcherService
{
    public abstract class DispatcherServiceEndpoints
    {
        private const string _apiVersion = "/api/v1";
        public const string SendNotification = $"{_apiVersion}/notifications/send";
        public const string SendEmail = $"{_apiVersion}/emails/send";
    }
}
