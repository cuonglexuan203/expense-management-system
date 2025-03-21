using EMS.API.Hubs.Interfaces;
using EMS.Application.Features.Chats.Common.Dtos;
using EMS.Application.Features.Chats.Finance.Commands.SendMessage;
using MediatR;
using Microsoft.AspNetCore.SignalR;

namespace EMS.API.Hubs
{
    public class FinancialChatHub : Hub<IFinancialChatClient>
    {
        private readonly ILogger<FinancialChatHub> _logger;
        private readonly ISender _sender;

        public FinancialChatHub(
            ILogger<FinancialChatHub> logger,
            ISender sender)
        {
            _logger = logger;
            _sender = sender;
        }

        public override Task OnConnectedAsync()
        {
            _logger.LogInformation("Client connected: {ConnectionId}", Context.ConnectionId);
            return base.OnConnectedAsync();
        }

        public override Task OnDisconnectedAsync(Exception? exception)
        {
            _logger.LogInformation("Client disconnected: {ConnectionId}", Context.ConnectionId);
            return base.OnDisconnectedAsync(exception);
        }

        public async Task JoinChat(string chatThreadId)
        {
            await Groups.AddToGroupAsync(Context.ConnectionId, chatThreadId);
            _logger.LogInformation("User {UserIdentifier} joined chat {ChatThreadId}",
                Context.UserIdentifier,
                chatThreadId);
        }

        public async Task LeaveChat(string chatThreadId)
        {
            await Groups.RemoveFromGroupAsync(Context.ConnectionId, chatThreadId);
            _logger.LogInformation("User {UserIdentifier} left chat {chatThreadId}",
                Context.UserIdentifier,
                chatThreadId);
        }

        public async Task<ChatMessageDto> SendMessage(int walletId, int chatThreadId, string text)
        {
            var userId = Context.UserIdentifier!;
            _logger.LogInformation("Message received from {UserId} in chat {ChatThreadId}", userId, chatThreadId);

            var command = new SendMessageCommand
            {
                UserId = userId,
                WalletId = walletId,
                ChatThreadId = chatThreadId,
                Text = text
            };

            try
            {
                var result = await _sender.Send(command);

                return result;
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error processing message");
                throw;
            }
        }
    }
}
