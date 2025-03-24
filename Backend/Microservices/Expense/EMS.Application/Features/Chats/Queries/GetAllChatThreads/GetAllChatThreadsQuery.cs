using AutoMapper;
using EMS.Application.Common.Extensions;
using EMS.Application.Common.Interfaces.DbContext;
using EMS.Application.Common.Interfaces.Services;
using EMS.Application.Features.Chats.Common.Dtos;
using MediatR;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Logging;

namespace EMS.Application.Features.Chats.Queries.GetAllChatThreads
{
    public record GetAllChatThreadsQuery : IRequest<List<ChatThreadDto>>;

    public class GetAllChatThreadsQueryHandler : IRequestHandler<GetAllChatThreadsQuery, List<ChatThreadDto>>
    {
        private readonly ILogger<GetAllChatThreadsQueryHandler> _logger;
        private readonly IApplicationDbContext _context;
        private readonly ICurrentUserService _currentUserService;
        private readonly IMapper _mapper;

        public GetAllChatThreadsQueryHandler(
            ILogger<GetAllChatThreadsQueryHandler> logger,
            IApplicationDbContext context,
            ICurrentUserService currentUserService,
            IMapper mapper)
        {
            _logger = logger;
            _context = context;
            _currentUserService = currentUserService;
            _mapper = mapper;
        }

        public async Task<List<ChatThreadDto>> Handle(GetAllChatThreadsQuery request, CancellationToken cancellationToken)
        {
            var userId = _currentUserService.Id!;

            var chatThreadDtoList = await _context.ChatThreads
                .AsNoTracking()
                .Where(e => e.UserId == userId && !e.IsDeleted)
                .OrderBy(e => e.CreatedAt)
                .ProjectToListAsync<ChatThreadDto>(_mapper.ConfigurationProvider);

            return chatThreadDtoList;
        }
    }
}
