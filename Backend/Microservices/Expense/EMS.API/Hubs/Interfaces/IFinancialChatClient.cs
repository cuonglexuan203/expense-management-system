namespace EMS.API.Hubs.Interfaces
{
    public interface IFinancialChatClient
    {
        Task ReceiveMessage(object message);
    }
}
