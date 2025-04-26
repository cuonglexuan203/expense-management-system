using AutoMapper;
using AutoMapper.QueryableExtensions;
using EMS.Application.Common.Exceptions;
using EMS.Application.Common.Interfaces.DbContext;
using EMS.Application.Common.Interfaces.Services;
using EMS.Application.Features.ExtractedTransactions.Dtos;
using MediatR;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Logging;

namespace EMS.Application.Features.ExtractedTransactions.Queries.GetChatThreadById
{
    public record GetChatThreadByIdQuery(int chatThreadId) : IRequest<ChatThreadDto>;

    public class GetChatThreadByIdQueryHandler : IRequestHandler<GetChatThreadByIdQuery, ChatThreadDto>
    {
        private readonly ILogger<GetChatThreadByIdQueryHandler> _logger;
        private readonly IApplicationDbContext _context;
        private readonly ICurrentUserService _currentUserService;
        private readonly IMapper _mapper;

        public GetChatThreadByIdQueryHandler(
            ILogger<GetChatThreadByIdQueryHandler> logger,
            IApplicationDbContext context,
            ICurrentUserService currentUserService,
            IMapper mapper)
        {
            _logger = logger;
            _context = context;
            _currentUserService = currentUserService;
            _mapper = mapper;
        }
        public async Task<ChatThreadDto> Handle(GetChatThreadByIdQuery request, CancellationToken cancellationToken)
        {
            var userId = _currentUserService.Id!;

            var chatThreadDto = await _context.ChatThreads
                .AsNoTracking()
                .Where(e => e.Id == request.chatThreadId && e.UserId == userId && !e.IsDeleted)
                .ProjectTo<ChatThreadDto>(_mapper.ConfigurationProvider)
                .FirstOrDefaultAsync()
                ?? throw new NotFoundException($"Chat thread with id {request.chatThreadId} not found.");

            return chatThreadDto;
        }
    }
}
