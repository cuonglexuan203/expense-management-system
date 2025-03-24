using AutoMapper;
using EMS.Application.Common.Interfaces.DbContext;
using EMS.Application.Features.Chats.Common.Dtos;
using EMS.Application.Features.Chats.Common.Services;
using EMS.Infrastructure.Persistence.Seed;
using Microsoft.Extensions.Logging;

namespace EMS.Infrastructure.Services
{
    public class ChatThreadService : IChatThreadService
    {
        private readonly ILogger<ChatThreadService> _logger;
        private readonly IApplicationDbContext _context;
        private readonly IMapper _mapper;

        public ChatThreadService(
            ILogger<ChatThreadService> logger,
            IApplicationDbContext context,
            IMapper mapper)
        {
            _logger = logger;
            _context = context;
            _mapper = mapper;
        }

        public async Task<List<ChatThreadDto>> CreateDefaultChatThreadsAsync(string userId)
        {
            try
            {
                var defaultChatThreads = DefaultSeedData.GetDefaultChatThreads(userId);

                _context.ChatThreads.AddRange(defaultChatThreads);
                await _context.SaveChangesAsync();

                _logger.LogInformation("Created default chat threads for user {userId}", userId);

                return _mapper.Map<List<ChatThreadDto>>(defaultChatThreads);
            }
            catch (Exception)
            {
                _logger.LogError("Error creating default chat threads for user {userId}", userId);

                throw;
            }
        }
    }
}
