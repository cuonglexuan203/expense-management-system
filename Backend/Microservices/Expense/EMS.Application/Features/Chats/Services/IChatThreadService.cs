using EMS.Application.Features.Chats.Dtos;

namespace EMS.Application.Features.Chats.Services
{
    public interface IChatThreadService
    {
        Task<List<ChatThreadDto>> CreateDefaultChatThreadsAsync(string userId);
    }
}
