using AutoMapper;
using EMS.Application.Common.Exceptions;
using EMS.Application.Common.Interfaces.DbContext;
using EMS.Application.Features.Chats.Common.Dtos;
using EMS.Core.Enums;
using EMS.Core.Specifications;
using MediatR;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Logging;

namespace EMS.Application.Features.AiTools.Queries.GetMessages
{
    public record GetMessagesQuery(string UserId, int ChatThreadId, ChatMessageSpecParams SpecParams) : IRequest<List<ChatMessageDto>>;

    public class GetMessagesQueryHandler : IRequestHandler<GetMessagesQuery, List<ChatMessageDto>>
    {
        private readonly ILogger<GetMessagesQueryHandler> _logger;
        private readonly IApplicationDbContext _context;
        private readonly IMapper _mapper;

        public GetMessagesQueryHandler(
            ILogger<GetMessagesQueryHandler> logger,
            IApplicationDbContext context,
            IMapper mapper)
        {
            _logger = logger;
            _context = context;
            _mapper = mapper;
        }

        public async Task<List<ChatMessageDto>> Handle(GetMessagesQuery request, CancellationToken cancellationToken)
        {
            var userId = request.UserId;
            var chatThreadId = request.ChatThreadId;
            var specParams = request.SpecParams;

            var chatThread = await _context.ChatThreads
                .AsNoTracking()
                .FirstOrDefaultAsync(e => e.Id == chatThreadId && e.UserId == userId && !e.IsDeleted)
                ?? throw new NotFoundException($"Chat thread with id {chatThreadId} not found.");

            var query = _context.ChatMessages
                .AsNoTracking()
                .AsSplitQuery()
                .Include(e => e.Medias.Where(e => !e.IsDeleted))
                .Include(e => e.ChatExtraction) // left join
                    .ThenInclude(e => e.ExtractedTransactions // left join
                        .Where(e => !e.IsDeleted)
                        .OrderByDescending(e => e.CreatedAt))
                .Where(e => e.ChatThreadId == chatThreadId &&
                    !e.ChatThread.IsDeleted &&
                    !e.IsDeleted);

            if (specParams.Role.HasValue)
            {
                query = query.Where(e => e.Role == specParams.Role);
            }

            if (!string.IsNullOrEmpty(specParams.Content))
            {
                query = query.Where(e => e.Content != null
                && DatabaseFunctions.Unaccent(e.Content.ToLower())
                .Contains(DatabaseFunctions.Unaccent(specParams.Content.ToLower())));
            }

            if (specParams.Sort == SortDirection.ASC)
            {
                query = query.OrderBy(e => e.CreatedAt);
            }
            else
            {
                query = query.OrderByDescending(e => e.CreatedAt);
            }

            var chatMessages = await query.ToListAsync();

            var chatMessageDtoList = new List<ChatMessageDto>();

            foreach (var chatMsg in chatMessages)
            {
                var chatMsgDto = _mapper.Map<ChatMessageDto>(chatMsg);
                chatMsgDto.ExtractedTransactions = chatMsg.ChatExtraction != null && chatMsg.ChatExtraction.ExtractedTransactions != null
                    ? _mapper.Map<List<ExtractedTransactionDto>>(chatMsg.ChatExtraction.ExtractedTransactions)
                    : [];

                chatMessageDtoList.Add(chatMsgDto);
            }

            return chatMessageDtoList;
        }
    }
}
