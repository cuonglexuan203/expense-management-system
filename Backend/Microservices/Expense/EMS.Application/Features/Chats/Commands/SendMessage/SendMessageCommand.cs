﻿using AutoMapper;
using EMS.Application.Common.Exceptions;
using EMS.Application.Common.Interfaces.DbContext;
using EMS.Application.Common.Interfaces.Messaging;
using EMS.Application.Features.ExtractedTransactions.Dtos;
using EMS.Application.Features.ExtractedTransactions.Messaging;
using EMS.Core.Entities;
using MediatR;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Logging;

namespace EMS.Application.Features.ExtractedTransactions.Commands.SendMessage
{
    public class SendMessageCommand : IRequest<ChatMessageDto>
    {
        public string UserId { get; set; } = default!;
        public int WalletId { get; set; }
        public int ChatThreadId { get; set; }
        public string? Text { get; set; }
        public bool HasFiles { get; set; } = false;
    }

    public class SendMessageCommandHandler : IRequestHandler<SendMessageCommand, ChatMessageDto>
    {
        private readonly ILogger<SendMessageCommandHandler> _logger;
        private readonly IApplicationDbContext _context;
        private readonly IMapper _mapper;
        private readonly IMessageQueue<QueryMessage> _messageQueue;

        public SendMessageCommandHandler(
            ILogger<SendMessageCommandHandler> logger,
            IApplicationDbContext context,
            IMapper mapper,
            IMessageQueue<QueryMessage> messageQueue)
        {
            _logger = logger;
            _context = context;
            _mapper = mapper;
            _messageQueue = messageQueue;
        }

        public async Task<ChatMessageDto> Handle(SendMessageCommand request, CancellationToken cancellationToken)
        {
            var chatThread = await _context.ChatThreads
                .AsNoTracking()
                .FirstOrDefaultAsync(e => e.UserId == request.UserId && e.Id == request.ChatThreadId && !e.IsDeleted)
                ?? throw new NotFoundException($"Chat thread with id {request.ChatThreadId} not found.");

            var isChatThreadActive = chatThread.IsActive;
            if (!isChatThreadActive)
            {
                throw new InvalidOperationException("Chat thread is not active");
            }

            // Save a new message
            var userId = request.UserId;
            var message = ChatMessage.CreateHumanMessage(userId!, request.ChatThreadId, request.Text);

            _context.ChatMessages.Add(message);
            await _context.SaveChangesAsync();

            await ValidateWallet(userId, request.WalletId);

            // Asynchronously process the message, intentionally sending an immediate acknowledgment to the frontend to prevent UI freezing.
            //_ = _mediator.Send(new ProcessMessageCommand(userId, request.WalletId, message.Id));
            if (!request.HasFiles) // Defer enqueue message when media files uploaded successfully
            {
                await _messageQueue.EnqueueAsync(new(userId, request.WalletId, message.ChatThreadId, message.Id), cancellationToken);
            }

            return _mapper.Map<ChatMessageDto>(message);
        }

        private async Task ValidateWallet(string userId, int walletId)
        {
            var wallet = await _context.Wallets
                .FirstOrDefaultAsync(e => e.Id == walletId && e.UserId == userId && !e.IsDeleted)
                ?? throw new NotFoundException($"Wallet with id {walletId} not found");
        }
    }
}
