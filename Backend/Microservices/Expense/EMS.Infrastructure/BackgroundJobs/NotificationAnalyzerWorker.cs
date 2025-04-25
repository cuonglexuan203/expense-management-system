using EMS.Application.Common.Interfaces.Messaging;
using EMS.Application.Common.Interfaces.Services;
using EMS.Application.Common.Interfaces.Services.HttpClients;
using EMS.Application.Features.Notifications.Commands.AnalyzeNotification;
using EMS.Core.Constants;
using EMS.Core.Entities;
using EMS.Core.Enums;
using EMS.Core.Exceptions;
using EMS.Infrastructure.Common.Options;
using EMS.Infrastructure.Persistence.DbContext;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.Hosting;
using Microsoft.Extensions.Logging;
using Microsoft.Extensions.Options;
using System.Text.Json;

namespace EMS.Infrastructure.BackgroundJobs
{
    public class NotificationAnalyzerWorker : BackgroundService
    {
        private readonly ILogger<NotificationAnalyzerWorker> _logger;
        private readonly IMessageQueueService _mqService;
        private readonly IServiceProvider _serviceProvider;
        private readonly RedisOptions _redisOptions;

        public NotificationAnalyzerWorker(
            ILogger<NotificationAnalyzerWorker> logger,
            IMessageQueueService mqService,
            IOptions<RedisOptions> redisOptions,
            IServiceProvider serviceProvider)
        {
            _logger = logger;
            _mqService = mqService;
            _serviceProvider = serviceProvider;
            _redisOptions = redisOptions.Value;
        }
        protected override async Task ExecuteAsync(CancellationToken stoppingToken)
        {
            _logger.LogInformation("Notification analyzer starting");

            while (!stoppingToken.IsCancellationRequested)
            {
                try
                {
                    var notification = await _mqService.DequeueAsync<NotificationMessage>(
                        _redisOptions.MessageQueues.NotificationExtractionQueue,
                        TimeSpan.FromSeconds(5),
                        stoppingToken);

                    if (notification != null)
                    {
                        await AnalyzeNotificationAsync(notification, stoppingToken);
                    }
                }
                catch (Exception ex)
                {
                    _logger.LogError(ex, "An error occurred while analyzing notification: {ErrMsg}", ex.Message);

                    await Task.Delay(500, stoppingToken);
                }
            }

            _logger.LogInformation("Notification analyzer stopping");
        }

        private async Task AnalyzeNotificationAsync(NotificationMessage notificationMsg, CancellationToken stoppingToken)
        {
            _logger.LogInformation(
                "Processing notification: user ID {UserId}, app name {AppName}, title {Title}",
                notificationMsg.UserId,
                notificationMsg.AppName,
                notificationMsg.Title);

            using var scope = _serviceProvider.CreateScope();
            var aiService = scope.ServiceProvider.GetRequiredService<IAiService>();
            var dispatcherService = scope.ServiceProvider.GetRequiredService<IDispatcherService>();
            var userPreferenceService = scope.ServiceProvider.GetRequiredService<IUserPreferenceService>();
            var context = scope.ServiceProvider.GetRequiredService<ApplicationDbContext>();

            try
            {
                var userPreferences = await userPreferenceService.GetUserPreferenceByIdAsync(notificationMsg.UserId);
                var categories = await context.Categories
                    .Where(e => !e.IsDeleted && e.UserId == notificationMsg.UserId)
                    .ToListAsync();

                var message = $"""
                    My notification
                    APP: {notificationMsg.AppName}
                    Title: {notificationMsg.Title}
                    Content: {notificationMsg.Content}
                    Pushed At: {notificationMsg.CreatedAt}
                    Metadata: {notificationMsg.Metadata}
                    """;
                var result = await aiService.AnalyzeTextMessageAsync(new(
                    notificationMsg.UserId,
                    0,
                    message,
                    categories.Select(e => e.Name).ToArray(),
                    userPreferences));

                if (result.Transactions.Length == 0 || result.Notification == null)
                {
                    return;
                }

                #region Persist notification & extracted transactions
                var extractedTransactionDtoList = result.Transactions;

                var extractedTransactionList = new List<ExtractedTransaction>();
                foreach (var item in extractedTransactionDtoList)
                {
                    try
                    {
                        var extractedTransaction = new ExtractedTransaction
                        {
                            UserId = notificationMsg.UserId,
                            Name = item.Name,
                            Type = item.Type,
                            Amount = item.Amount,
                            OccurredAt = item.OccurredAt,
                        };

                        Category? category = default;

                        if (item.Category != null)
                        {
                            category = categories.Where(c => c.Name.Equals(item.Category, StringComparison.OrdinalIgnoreCase)).FirstOrDefault();
                        }

                        if (category == null)
                        {
                            category = await context.Categories
                                .Where(e => !e.IsDeleted &&
                                            e.Type == CategoryType.Default &&
                                            e.FinancialFlowType == item.Type &&
                                            e.Name == Categories.Unknown)
                                .FirstOrDefaultAsync() ?? throw new ServerException("The system unknown category not found.");
                        }

                        //extractedTransaction.CategoryId = category.Id;
                        extractedTransaction.Category = category;
                        extractedTransaction.CurrencyCode = userPreferences.CurrencyCode;
                        extractedTransaction.ConfirmationMode = userPreferences.ConfirmationMode;
                        // NOTE: Pending for all confirmation modes, users have to confirm/reject manually
                        extractedTransaction.ConfirmationStatus = ConfirmationStatus.Pending;

                        extractedTransactionList.Add(extractedTransaction);
                    }
                    catch (Exception ex)
                    {
                        _logger.LogError("An error occurred while extracting a transaction {@ExtractedTransaction} from the notification {@Notification} - Error message: {Msg}",
                            item,
                            notificationMsg,
                            ex.Message);
                    }
                }

                var pushNotification = result.Notification;
                var notification = new Notification
                {
                    UserId = notificationMsg.UserId,
                    Type = NotificationType.NotificationAnalysis,
                    Title = pushNotification.Title,
                    Body = pushNotification.Body,
                    Status = NotificationStatus.Queued,
                    ExtractedTransactions = extractedTransactionList,
                };
                context.Notifications.Add(notification);
                #endregion

                await context.SaveChangesAsync();

                // Save custom data
                var customData = new Dictionary<string, string>
                {
                    ["notification_id"] = notification.Id.ToString(),
                };
                notification.DataPayload = JsonSerializer.Serialize(customData);
                await context.SaveChangesAsync();

                var pushResult = await dispatcherService.SendNotification(new(
                    notificationMsg.UserId,
                    pushNotification.Title,
                    pushNotification.Body,
                    customData));

                if (pushResult != null)
                {
                    _logger.LogInformation("Push Notification completed: {Status}, {SuccessCount} succeeded, {FailureCount} failed",
                        pushResult.Data.Status,
                        pushResult.Data.SuccessCount,
                        pushResult.Data.FailureCount);
                }
                else
                {
                    _logger.LogInformation("Push Notification completed.");
                }
            }
            catch (Exception ex)
            {
                _logger.LogError(
                    ex,
                    "Failed to analyze notification {@Notification}: {ErrMsg}",
                    notificationMsg,
                    ex.Message);

                // dead-letter queue implementation for failed notifications
            }
        }
    }
}
