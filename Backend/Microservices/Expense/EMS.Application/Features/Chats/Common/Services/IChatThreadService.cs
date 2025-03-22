namespace EMS.Application.Features.Chats.Common.Services
{
    public interface IChatThreadService
    {
        Task<bool> IsChatThreadActiveAsync(int chatThreadId);
    }
}
