namespace EMS.Application.Features.Chats.Finance.Services
{
    public interface IFinancialChatNotifier
    {
        Task NotifyMessageProcessedToUserAsync(string userId, object message);
    }
}
