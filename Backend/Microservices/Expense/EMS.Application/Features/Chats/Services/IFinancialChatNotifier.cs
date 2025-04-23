namespace EMS.Application.Features.Chats.Services
{
    public interface IFinancialChatNotifier
    {
        Task NotifyMessageProcessedToUserAsync(string userId, object message);
    }
}
