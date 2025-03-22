using EMS.Application.Features.Chats.Common.Dtos;
using EMS.Application.Features.Chats.Finance.Services;
using MediatR;
using Microsoft.Extensions.Logging;

namespace EMS.Application.Features.Chats.Finance.Notifications.MessageProcessed
{
    public class MessageProcessedNotification : INotification
    {
        public string UserId { get; set; } = default!;
        public int WalletId { get; set; }
        public int ChatThreadId { get; set; }
        public ChatMessageDto SystemMessage { get; set; } = default!;
        public List<ExtractedTransactionDto> ExtractedTransactions { get; set; } = [];

        public MessageProcessedNotification()
        {
            
        }

        public MessageProcessedNotification(string userId, int walletId, int chatThreadId, ChatMessageDto systemMessage, List<ExtractedTransactionDto> extractedTransactions)
        {
            UserId = userId;
            WalletId = walletId;
            ChatThreadId = chatThreadId;
            SystemMessage = systemMessage;
            ExtractedTransactions = extractedTransactions;
        }
    }

    public class MessageProcessedNotificationHandler : INotificationHandler<MessageProcessedNotification>
    {
        private readonly ILogger<MessageProcessedNotificationHandler> _logger;
        private readonly IFinancialChatNotifier _notifier;

        public MessageProcessedNotificationHandler(
            ILogger<MessageProcessedNotificationHandler> logger,
            IFinancialChatNotifier notifier)
        {
            _logger = logger;
            _notifier = notifier;
        }

        public async Task Handle(MessageProcessedNotification notification, CancellationToken cancellationToken)
        {
            await _notifier.NotifyMessageProcessedToUserAsync(notification.UserId, notification);
            _logger.LogInformation("Sent a processed message to user {UserId}", notification.UserId);
        }
    }
}
