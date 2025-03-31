using AutoMapper;
using EMS.Application.Common.DTOs;
using EMS.Application.Common.Exceptions;
using EMS.Application.Common.Extensions;
using EMS.Application.Common.Interfaces.Messaging;
using EMS.Application.Common.Interfaces.Services;
using EMS.Application.Common.Interfaces.Services.HttpClients;
using EMS.Application.Features.Categories.Services;
using EMS.Application.Features.Chats.Common.Dtos;
using EMS.Application.Features.Chats.Finance.Messaging;
using EMS.Application.Features.Chats.Finance.Notifications.MessageProcessed;
using EMS.Application.Features.Transactions.Services;
using EMS.Application.Features.Wallets.Services;
using EMS.Core.Constants;
using EMS.Core.Entities;
using EMS.Core.Enums;
using EMS.Infrastructure.Persistence.DbContext;
using MediatR;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.Hosting;
using Microsoft.Extensions.Logging;
using System.Text.Json;

namespace EMS.Infrastructure.BackgroundJobs
{
    public class TransactionProcessingService : BackgroundService
    {
        private readonly ILogger<TransactionProcessingService> _logger;
        private readonly IMessageQueue<TransactionProcessingMessage> _messageQueue;
        private readonly IServiceProvider _serviceProvider;

        public TransactionProcessingService(
            ILogger<TransactionProcessingService> logger,
            IMessageQueue<TransactionProcessingMessage> messageQueue,
            IServiceProvider serviceProvider)
        {
            _logger = logger;
            _messageQueue = messageQueue;
            _serviceProvider = serviceProvider;
        }
        protected override async Task ExecuteAsync(CancellationToken stoppingToken)
        {
            _logger.LogStateInfo(AppStates.RunningBackgroundJobs, $"Transaction processing service starting");
            await foreach (var message in _messageQueue.DequeueAsync(stoppingToken))
            {
                try
                {
                    await ProcessMessageAsync(message, stoppingToken);
                }
                catch (Exception ex)
                {
                    _logger.LogError(ex, "Error processing transaction message for UserId: {UserId}, MessageId: {MessageId}",
                        message.UserId,
                        message.MessageId);
                }
            }
        }

        private async Task ProcessMessageAsync(TransactionProcessingMessage queuedMessage, CancellationToken stoppingToken)
        {
            _logger.LogInformation("Processing transaction message: {MessageId}", queuedMessage.MessageId);

            // Resolve scoped services
            using var scope = _serviceProvider.CreateScope();
            var mediator = scope.ServiceProvider.GetRequiredService<IMediator>();
            var context = scope.ServiceProvider.GetRequiredService<ApplicationDbContext>();
            var aiService = scope.ServiceProvider.GetRequiredService<IAiService>();
            var userPreferenceService = scope.ServiceProvider.GetRequiredService<IUserPreferenceService>();
            var transactionService = scope.ServiceProvider.GetRequiredService<ITransactionService>();
            var categoryService = scope.ServiceProvider.GetRequiredService<ICategoryService>();
            var mapper = scope.ServiceProvider.GetRequiredService<IMapper>();
            var dbTransactionManager = scope.ServiceProvider.GetRequiredService<IDatabaseTransactionManager>();
            var walletService = scope.ServiceProvider.GetRequiredService<IWalletService>();

            try
            {
                // Retrieve msg from db
                var message = await context.ChatMessages
                    .AsNoTracking()
                    .FirstOrDefaultAsync(e => e.Id == queuedMessage.MessageId && e.ChatThreadId == queuedMessage.ChatThreadId && !e.IsDeleted)
                    ?? throw new NotFoundException($"Message with Id {queuedMessage.MessageId} not found");
                var chatThreadId = message.ChatThreadId;

                var userPreferences = await userPreferenceService.GetUserPreferenceByIdAsync(queuedMessage.UserId);
                var defaultCategories = await categoryService.GetDefaultCategoriesAsync();

                // Get transaction extraction
                var msgExtractionRequest = new MessageExtractionRequest(chatThreadId, message.Content!, defaultCategories, userPreferences);
                var extractionResult = await aiService.ExtractTransactionAsync(msgExtractionRequest);

                // Save system msg
                var systemMsg = ChatMessage.CreateSystemMessage(chatThreadId, extractionResult.Introduction);
                context.ChatMessages.Add(systemMsg);

                // Save raw extraction
                var chatExtraction = new ChatExtraction
                {
                    ChatMessageId = systemMsg.Id,
                    ExtractionType = ExtractionType.Transaction,
                    ExtractedData = JsonSerializer.Serialize(extractionResult),
                };
                systemMsg.ChatExtraction = chatExtraction; // redundant but for clearer flow

                // Save extracted transactions
                if (extractionResult.CategorizedItems.Length != 0)
                {
                    foreach (var item in extractionResult.CategorizedItems)
                    {
                        try
                        {
                            var extractedTransaction = new ExtractedTransaction
                            {
                                Name = item.Name,
                                Type = item.Type,
                                Amount = item.Amount,
                                OccurredAt = item.OccurredAt,
                            };

                            var category = item.Category != null ?
                                await context.Categories
                                .AsNoTracking()
                                .FirstOrDefaultAsync(e => e.Name == item.Category && e.UserId == queuedMessage.UserId && !e.IsDeleted) :
                                await categoryService.GetUnknownCategoryAsync(item.Type);

                            if (category == null)
                            {
                                category = await categoryService.GetUnknownCategoryAsync(item.Type);
                            }

                            extractedTransaction.CategoryId = category.Id;
                            extractedTransaction.CurrencyCode = userPreferences.CurrencyCode;
                            extractedTransaction.ConfirmationMode = userPreferences.ConfirmationMode;
                            // NOTE: Pending for all confirmation modes, and will be modified when processing each mode later 
                            extractedTransaction.ConfirmationStatus = ConfirmationStatus.Pending;

                            chatExtraction.ExtractedTransactions.Add(extractedTransaction);
                        }
                        catch (Exception ex)
                        {
                            _logger.LogError("An error occurred while extracting a transaction from {@ExtractedTransaction} - Error message: {Msg}",
                                item,
                                ex.Message);
                        }
                    }
                }

                // Save extracted data before processing transaction entities within the same db transaction to ensure atomicity.
                await context.SaveChangesAsync(stoppingToken);

                if (userPreferences.ConfirmationMode == ConfirmationMode.Auto)
                {
                    await dbTransactionManager.ExecuteInTransactionAsync(async () =>
                    {
                        var transactions = new List<Transaction>();
                        foreach (var item in chatExtraction.ExtractedTransactions)
                        {
                            item.ConfirmationStatus = ConfirmationStatus.Confirmed;
                            var transaction = Transaction.CreateFrom(item, queuedMessage.UserId, queuedMessage.WalletId, queuedMessage.MessageId);

                            if (transaction != null)
                            {
                                transaction.ExtractedTransaction = item;
                                transactions.Add(transaction);
                            }
                        }

                        var transactionDtoList = await transactionService.CreateTransactionsAsync(queuedMessage.UserId, queuedMessage.WalletId, transactions);
                    }, clearChangeTrackerOnRollback: true);

                    await walletService.CacheWalletBalanceSummariesAsync(queuedMessage.UserId, queuedMessage.WalletId);
                }

                await mediator.Publish(new MessageProcessedNotification()
                {
                    UserId = queuedMessage.UserId,
                    WalletId = queuedMessage.WalletId,
                    ChatThreadId = chatThreadId,
                    SystemMessage = mapper.Map<ChatMessageDto>(systemMsg),
                    ExtractedTransactions = mapper.Map<List<ExtractedTransactionDto>>(chatExtraction.ExtractedTransactions)
                }, stoppingToken);
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error processing message {MessageId}", queuedMessage.MessageId);

                var errorMsg = ChatMessage.CreateSystemMessage(
                    queuedMessage.ChatThreadId,
                    "Sorry, I encountered an error processing your request. Please try again.");

                context.ChatMessages.Add(errorMsg);
                await context.SaveChangesAsync(stoppingToken);

                await mediator.Publish(new MessageProcessedNotification
                {
                    UserId = queuedMessage.UserId,
                    WalletId = queuedMessage.WalletId,
                    ChatThreadId = queuedMessage.ChatThreadId,
                    SystemMessage = mapper.Map<ChatMessageDto>(errorMsg),
                    ExtractedTransactions = new List<ExtractedTransactionDto>(),
                    HasError = true
                }, stoppingToken);
            }
        }
    }
}
