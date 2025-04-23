using AutoMapper;
using EMS.Application.Common.Exceptions;
using EMS.Application.Common.Extensions;
using EMS.Application.Common.Interfaces.Messaging;
using EMS.Application.Common.Interfaces.Services;
using EMS.Application.Common.Interfaces.Services.HttpClients;
using EMS.Application.Features.Categories.Services;
using EMS.Application.Features.ExtractedTransactions.Dtos;
using EMS.Application.Features.ExtractedTransactions.Messaging;
using EMS.Application.Features.ExtractedTransactions.Notifications.MessageProcessed;
using EMS.Application.Features.Transactions.Services;
using EMS.Application.Features.Wallets.Services;
using EMS.Core.Constants;
using EMS.Core.Entities;
using EMS.Core.Enums;
using EMS.Core.Exceptions;
using EMS.Infrastructure.Persistence.DbContext;
using MediatR;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.Hosting;
using Microsoft.Extensions.Logging;
using System.Text.Json;

namespace EMS.Infrastructure.BackgroundJobs
{
    public class AssistantMessageProcessorWorker : BackgroundService
    {
        private readonly ILogger<AssistantMessageProcessorWorker> _logger;
        private readonly IMessageQueue<QueryMessage> _messageQueue;
        private readonly IServiceProvider _serviceProvider;

        public AssistantMessageProcessorWorker(
            ILogger<AssistantMessageProcessorWorker> logger,
            IMessageQueue<QueryMessage> messageQueue,
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

        private async Task ProcessMessageAsync(QueryMessage queuedMessage, CancellationToken stoppingToken)
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
                    .Where(e => e.Id == queuedMessage.MessageId && e.ChatThreadId == queuedMessage.ChatThreadId && !e.IsDeleted)
                    .Include(e => e.Medias.Where(media => !media.IsDeleted))
                    .FirstOrDefaultAsync()
                    ?? throw new NotFoundException($"Message with Id {queuedMessage.MessageId} not found");
                var chatThreadId = message.ChatThreadId;

                var userPreferences = await userPreferenceService.GetUserPreferenceByIdAsync(queuedMessage.UserId);
                var categories = await context.Categories
                    .Where(e => !e.IsDeleted && e.UserId == queuedMessage.UserId)
                    .ToListAsync();

                #region Old implementation: Only extract transactions
                /*
                // Get transaction extractions
                MessageExtractionResponse extractionResult = default!;

                if ((message.MessageTypes & MessageTypes.Image) == MessageTypes.Image)
                {
                    extractionResult = await aiService.ExtractTransactionFromImagesAsync(
                        new(
                            queuedMessage.UserId,
                            chatThreadId,
                            message.Content!,
                            message.Medias.Where(e => !string.IsNullOrEmpty(e.Url)).Select(e => e.Url!).ToArray(),
                            defaultCategories.Select(e => e.Name).ToArray(),
                            userPreferences));
                }
                else if ((message.MessageTypes & MessageTypes.Audio) == MessageTypes.Audio)
                {
                    extractionResult = await aiService.ExtractTransactionFromAudiosAsync(
                        new(
                            queuedMessage.UserId,
                            chatThreadId,
                            message.Content!,
                            message.Medias.Where(e => !string.IsNullOrEmpty(e.Url)).Select(e => e.Url!).ToArray(),
                            defaultCategories.Select(e => e.Name).ToArray(),
                            userPreferences));
                }
                else
                {
                    extractionResult = await aiService.ExtractTransactionAsync(
                        new(
                            queuedMessage.UserId,
                            chatThreadId,
                            message.Content!,
                            defaultCategories.Select(e => e.Name).ToArray(),
                            userPreferences));
                }
                */
                #endregion

                var assistantResponse = await aiService.ChatWithAssistant(new(
                    queuedMessage.UserId,
                    queuedMessage.WalletId,
                    chatThreadId,
                    message.Content,
                    message.Medias?.Where(e => !string.IsNullOrEmpty(e.Url)).Select(e => e.Url!).ToArray(),
                    categories.Select(e => e.Name).ToArray(),
                    userPreferences));

                // Save system msg
                var systemMsg = ChatMessage.CreateSystemMessage(chatThreadId, assistantResponse.LlmContent);
                context.ChatMessages.Add(systemMsg);

                // Save raw extraction
                var chatExtraction = new ChatExtraction
                {
                    ChatMessageId = systemMsg.Id,
                    ExtractionType = ExtractionType.Transaction, // REVIEW: could be Financial/Event for clear
                    ExtractedData = JsonSerializer.Serialize(assistantResponse),
                };
                systemMsg.ChatExtraction = chatExtraction; // redundant but for clearer flow

                // Save extracted transactions
                if (assistantResponse.Type == MessageRole.Ai
                    && assistantResponse.Name == Agents.FinancialExpert
                    && assistantResponse.FinancialResponse != null)
                {

                    ExtractedTransactionDto[] extractedTransactions = [
                        .. (assistantResponse.FinancialResponse.TextExtractions ?? []),
                        .. (assistantResponse.FinancialResponse.ImageExtractions ?? []),
                        .. (assistantResponse.FinancialResponse.AudioExtractions ?? [])
                    ];

                    if (extractedTransactions.Length != 0)
                    {
                        foreach (var item in extractedTransactions)
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

                await mediator.Publish(new MessageProcessedNotification
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

                context.ChangeTracker.Clear();

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
