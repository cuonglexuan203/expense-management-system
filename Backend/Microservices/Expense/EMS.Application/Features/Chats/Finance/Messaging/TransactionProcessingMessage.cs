namespace EMS.Application.Features.Chats.Finance.Messaging
{
    public record TransactionProcessingMessage(
        string UserId,
        int WalletId,
        int ChatThreadId,
        int MessageId);
}
