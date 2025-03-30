using EMS.API.Hubs.Interfaces;
using EMS.Application.Features.Chats.Common.Dtos;
using EMS.Application.Features.Chats.Finance.Commands.SendMessage;
using EMS.Infrastructure.SignalR;
using MediatR;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Http.Connections.Features;

namespace EMS.API.Hubs
{
    [Authorize]
    public class FinancialChatHub(
        SignalRConnectionManager connectionManager,
        ISignalRContextAccessor contextAccessor,
        ILogger<FinancialChatHub> logger,
        ISender sender) : EMSHubBase<IFinancialChatClient>(connectionManager, contextAccessor)
    {
        private readonly ILogger<FinancialChatHub> _logger = logger;
        private readonly ISender _sender = sender;

        public override Task OnConnectedAsync()
        {
            _logger.LogInformation("Client connected: {ConnectionId} using transport: {Transport}",
                Context.ConnectionId,
                Context.Features.Get<IHttpTransportFeature>()?.TransportType.ToString());

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

        public async Task<ChatMessageDto> SendMessageWithFiles(int walletId, int chatThreadId, string text)
        {
            var userId = Context.UserIdentifier!;
            _logger.LogInformation("Message received from {UserId} in chat {ChatThreadId}", userId, chatThreadId);

            var command = new SendMessageCommand
            {
                UserId = userId,
                WalletId = walletId,
                ChatThreadId = chatThreadId,
                Text = text,
                HasFiles = true
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
