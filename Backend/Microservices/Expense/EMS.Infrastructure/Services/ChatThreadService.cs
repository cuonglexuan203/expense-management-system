using EMS.Application.Common.Interfaces.DbContext;
using EMS.Application.Features.Chats.Common.Services;
using Microsoft.Extensions.Logging;

namespace EMS.Infrastructure.Services
{
    public class ChatThreadService : IChatThreadService
    {
        private readonly ILogger<ChatThreadService> _logger;
        private readonly IApplicationDbContext _context;

        public ChatThreadService(
            ILogger<ChatThreadService> logger,
            IApplicationDbContext context)
        {
            _logger = logger;
            _context = context;
        }
        public async Task<bool> IsChatThreadActiveAsync(int chatThreadId)
        {
            var chatThread = await _context.ChatThreads.FindAsync(chatThreadId);

            return chatThread?.IsActive ?? false;
        }
    }
}
