namespace EMS.Application.Features.Chats.Messaging
{
    /// <summary>
    /// Pending human message in queue
    /// </summary>
    public record QueryMessage(
        string UserId,
        int WalletId,
        int ChatThreadId,
        int MessageId);
}
