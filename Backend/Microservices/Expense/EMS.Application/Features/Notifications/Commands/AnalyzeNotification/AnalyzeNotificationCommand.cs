using EMS.Application.Common.Interfaces.Messaging;
using EMS.Application.Common.Interfaces.Services;
using MediatR;
using Microsoft.Extensions.Logging;

namespace EMS.Application.Features.Notifications.Commands.AnalyzeNotification
{
    public record AnalyzeNotificationCommand(
        string PackageName, // app name
        string Title,
        string Text,        // content
        Dictionary<string, object>? Extras) : IRequest<Unit>;

    public class AnalyzeNotificationCommandHandler : IRequestHandler<AnalyzeNotificationCommand, Unit>
    {
        private readonly ILogger<AnalyzeNotificationCommandHandler> _logger;
        private readonly IMessageQueueService _mqService;
        private readonly ICurrentUserService _currentUserService;

        public AnalyzeNotificationCommandHandler(
            ILogger<AnalyzeNotificationCommandHandler> logger,
            IMessageQueueService mqService,
            ICurrentUserService currentUserService)
        {
            _logger = logger;
            _mqService = mqService;
            _currentUserService = currentUserService;
        }
        public async Task<Unit> Handle(AnalyzeNotificationCommand request, CancellationToken cancellationToken)
        {
            var queueName = "notification-extraction";
            await _mqService.EnqueueAsync<NotificationMessage>(queueName, new()
            {
                UserId = _currentUserService.Id!,
                AppName = request.PackageName,
                Title = request.Title,
                Content = request.Text,
                Metadata = request.Extras,
                CreatedAt = DateTimeOffset.UtcNow,
            });

            _logger.LogInformation("Enqueued a notification to analyze into queue {QueueName}", queueName);

            return Unit.Value;
        }
    }
}
