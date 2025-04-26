using EMS.Application.Features.ExtractedTransactions.Dtos;

namespace EMS.Application.Features.ExtractedTransactions.Services
{
    public interface IChatThreadService
    {
        Task<List<ChatThreadDto>> CreateDefaultChatThreadsAsync(string userId);
    }
}
