namespace EMS.Application.Features.ExtractedTransactions.Services
{
    public interface IFinancialChatNotifier
    {
        Task NotifyMessageProcessedToUserAsync(string userId, object message);
    }
}
