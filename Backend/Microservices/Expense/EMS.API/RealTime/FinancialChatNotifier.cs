using EMS.API.Hubs;
using EMS.API.Hubs.Interfaces;
using EMS.Application.Features.Chats.Services;
using Microsoft.AspNetCore.SignalR;

namespace EMS.API.RealTime
{
    public class FinancialChatNotifier : IFinancialChatNotifier
    {
        private readonly ILogger<FinancialChatNotifier> _logger;
        private readonly IHubContext<FinancialChatHub, IFinancialChatClient> _hubContext;

        public FinancialChatNotifier(
            ILogger<FinancialChatNotifier> logger,
            IHubContext<FinancialChatHub, IFinancialChatClient> hubContext)
        {
            _logger = logger;
            _hubContext = hubContext;
        }

        public async Task NotifyMessageProcessedToUserAsync(string userId, object message)
        {
            await _hubContext.Clients.User(userId)
                .ReceiveMessage(message);
        }
    }
}
