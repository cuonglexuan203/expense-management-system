﻿using AutoMapper;
using EMS.Application.Common.Exceptions;
using EMS.Application.Common.Extensions;
using EMS.Application.Common.Interfaces.DbContext;
using EMS.Application.Common.Interfaces.Services;
using EMS.Application.Common.Models;
using EMS.Application.Features.ExtractedTransactions.Dtos;
using EMS.Core.Enums;
using EMS.Core.Specifications;
using MediatR;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Logging;

namespace EMS.Application.Features.ExtractedTransactions.Queries.GetMessages
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

            var chatMessagePage = await query.ToPaginatedList(specParams.PageNumber, specParams.PageSize);

            var chatMessageDtoList = new List<ChatMessageDto>();

            foreach (var chatMsg in chatMessagePage.Items)
            {
                var chatMsgDto = _mapper.Map<ChatMessageDto>(chatMsg);
                chatMsgDto.ExtractedTransactions = chatMsg.ChatExtraction != null && chatMsg.ChatExtraction.ExtractedTransactions != null
                    ? _mapper.Map<List<ExtractedTransactionDto>>(chatMsg.ChatExtraction.ExtractedTransactions)
                    : [];

                chatMessageDtoList.Add(chatMsgDto);
            }

            return new PaginatedList<ChatMessageDto>(chatMessageDtoList, chatMessagePage.TotalCount, chatMessagePage.PageNumber, chatMessagePage.PageSize);
        }
    }
}
