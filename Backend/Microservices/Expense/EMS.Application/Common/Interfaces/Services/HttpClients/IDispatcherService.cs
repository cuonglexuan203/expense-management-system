using EMS.Application.Common.DTOs.Dispatcher;
using EMS.Application.Common.Interfaces.Services.HttpClients.Common;

namespace EMS.Application.Common.Interfaces.Services.HttpClients
{
    public interface IDispatcherService : IHttpClientService
    {
        Task<NotificationDispatchResponse?> SendNotification(NotificationDispatchRequest msg);
        Task SendEmailAsync(EmailDispatchRequest msg);
    }
}
