using EMS.Application.Features.Chats.Common.Dtos;

namespace EMS.Application.Features.Chats.Common.Services
{
    public interface IChatThreadService
    {
        Task<List<ChatThreadDto>> CreateDefaultChatThreadsAsync(string userId);
    }
}
