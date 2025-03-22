using AutoMapper;
using EMS.Application.Common.Interfaces.DbContext;
using EMS.Application.Common.Interfaces.Services;
using EMS.Application.Features.Chats.Common.Dtos;
using EMS.Application.Features.Chats.Common.Services;
using EMS.Application.Features.Chats.Finance.Commands.ProcessMessage;
using EMS.Core.Entities;
using MediatR;
using Microsoft.Extensions.Logging;

namespace EMS.Application.Features.Chats.Finance.Commands.SendMessage
{
    public class SendMessageCommand : IRequest<ChatMessageDto>
    {
        public string UserId { get; set; } = default!;
        public int WalletId { get; set; }
        public int ChatThreadId { get; set; }
        public string Text { get; set; } = default!;
    }

    public class SendMessageCommandHandler : IRequestHandler<SendMessageCommand, ChatMessageDto>
    {
        private readonly ILogger<SendMessageCommandHandler> _logger;
        private readonly IChatThreadService _chatThreadService;
        private readonly IMediator _mediator;
        private readonly ICurrentUserService _currentUserService;
        private readonly IApplicationDbContext _context;
        private readonly IMapper _mapper;

        public SendMessageCommandHandler(
            ILogger<SendMessageCommandHandler> logger,
            IChatThreadService chatThreadService,
            IMediator mediator,
            ICurrentUserService currentUserService,
            IApplicationDbContext context,
            IMapper mapper)
        {
            _logger = logger;
            _chatThreadService = chatThreadService;
            _mediator = mediator;
            _currentUserService = currentUserService;
            _context = context;
            _mapper = mapper;
        }

        public async Task<ChatMessageDto> Handle(SendMessageCommand request, CancellationToken cancellationToken)
        {
            var isChatThreadActive = await _chatThreadService.IsChatThreadActiveAsync(request.ChatThreadId);
            if (!isChatThreadActive)
            {
                throw new InvalidOperationException("Chat thread is not active");
            }

            // Save a new message
            var userId = request.UserId;
            var message = ChatMessage.CreateUserMessage(request.ChatThreadId, userId!, request.Text);
            _context.ChatMessages.Add(message);
            await _context.SaveChangesAsync();

            // Asynchronously process the message, intentionally sending an immediate acknowledgment to the frontend to prevent UI freezing.
            _ = await _mediator.Send(new ProcessMessageCommand(userId, request.WalletId, message.Id));

            return _mapper.Map<ChatMessageDto>(message);
        }
    }
}
