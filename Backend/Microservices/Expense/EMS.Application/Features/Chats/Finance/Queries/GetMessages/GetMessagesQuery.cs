using AutoMapper;
using EMS.Application.Common.Extensions;
using EMS.Application.Common.Interfaces.DbContext;
using EMS.Application.Common.Interfaces.Services;
using EMS.Application.Common.Models;
using EMS.Application.Features.Chats.Common.Dtos;
using EMS.Core.Enums;
using EMS.Core.Specifications;
using MediatR;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Logging;

namespace EMS.Application.Features.Chats.Finance.Queries.GetMessages
{
    public record GetMessagesQuery(int ChatThreadId, ChatMessageSpecParams SpecParams) : IRequest<PaginatedList<ChatMessageDto>>;

    public class GetMessagesQueryHandler : IRequestHandler<GetMessagesQuery, PaginatedList<ChatMessageDto>>
    {
        private readonly ILogger<GetMessagesQueryHandler> _logger;
        private readonly IApplicationDbContext _context;
        private readonly ICurrentUserService _currentUserService;
        private readonly IMapper _mapper;

        public GetMessagesQueryHandler(
            ILogger<GetMessagesQueryHandler> logger,
            IApplicationDbContext context,
            ICurrentUserService currentUserService,
            IMapper mapper)
        {
            _logger = logger;
            _context = context;
            _currentUserService = currentUserService;
            _mapper = mapper;
        }

        public async Task<PaginatedList<ChatMessageDto>> Handle(GetMessagesQuery request, CancellationToken cancellationToken)
        {
            var userId = _currentUserService.Id!;
            var chatThreadId = request.ChatThreadId;
            var specParams = request.SpecParams;

            var query = _context.ChatMessages
                .AsNoTracking()
                .Where(e => e.UserId == userId && e.ChatThreadId == chatThreadId && !e.ChatThread.IsDeleted && !e.IsDeleted);

            if(specParams.Role != null)
            {
                query = query.Where(e => e.Role == specParams.Role);
            }

            if(specParams.Content != null)
            {
                query = query.Where(e => e.Content != null && e.Content.Contains(specParams.Content));
            }

            if(specParams.Sort == SortDirection.ASC)
            {
                query = query.OrderBy(e => e.CreatedAt);
            }
            else
            {
                query = query.OrderByDescending(e => e.CreatedAt);
            }

            var dtoQuery = _mapper.ProjectTo<ChatMessageDto>(query);

            var result = await dtoQuery.ToPaginatedList(specParams.PageNumber, specParams.PageSize);

            return result;
        }
    }
}
