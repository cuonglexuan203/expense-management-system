using AutoMapper;
using EMS.Application.Common.DTOs;
using EMS.Application.Common.Exceptions;
using EMS.Application.Common.Interfaces.DbContext;
using EMS.Application.Common.Interfaces.Services;
using EMS.Application.Common.Interfaces.Services.HttpClients;
using EMS.Application.Features.Categories.Services;
using EMS.Application.Features.Chats.Common.Dtos;
using EMS.Application.Features.Chats.Finance.Notifications.MessageProcessed;
using EMS.Application.Features.Transactions.Services;
using EMS.Core.Entities;
using EMS.Core.Enums;
using MediatR;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Logging;
using System.Text.Json;

namespace EMS.Application.Features.Chats.Finance.Commands.ProcessMessage
{
    // Unused - Retained as a fallback method
    public record ProcessMessageCommand(string UserId, int WalletId, int MessageId) : IRequest<Unit>;

    public class ProcessMessageCommandHandler : IRequestHandler<ProcessMessageCommand, Unit>
    {
        private readonly ILogger<ProcessMessageCommandHandler> _logger;
        private readonly IApplicationDbContext _context;
        private readonly IAiService _aiService;
        private readonly IUserPreferenceService _userPreferenceService;
        private readonly ICategoryService _categoryService;
        private readonly ITransactionService _transactionService;
        private readonly IMediator _mediator;
        private readonly IMapper _mapper;

        public ProcessMessageCommandHandler(
            ILogger<ProcessMessageCommandHandler> logger,
            IApplicationDbContext context,
            IAiService aiService,
            IUserPreferenceService userPreferenceService,
            ICategoryService categoryService,
            ITransactionService transactionService,
            IMediator mediator,
            IMapper mapper)
        {
            _logger = logger;
            _context = context;
            _aiService = aiService;
            _userPreferenceService = userPreferenceService;
            _categoryService = categoryService;
            _transactionService = transactionService;
            _mediator = mediator;
            _mapper = mapper;
        }

        public async Task<Unit> Handle(ProcessMessageCommand request, CancellationToken cancellationToken)
        {
            // Retrieve msg from db
            var message = await _context.ChatMessages
                .FirstOrDefaultAsync(e => e.Id == request.MessageId && !e.IsDeleted)
                ?? throw new NotFoundException($"Message with Id {request.MessageId} not found");
            var chatThreadId = message.ChatThreadId;

            // Get transaction extraction
            var msgExtractionRequest = new MessageExtractionRequest(chatThreadId, message.Content!);
            var extractionResult = await _aiService.ExtractTransactionAsync(msgExtractionRequest);

            // Save system msg
            var systemMsg = ChatMessage.CreateSystemMessage(chatThreadId, extractionResult.Introduction);
            _context.ChatMessages.Add(systemMsg);

            // Save raw extraction
            var chatExtraction = new ChatExtraction
            {
                ChatMessageId = message.Id,
                ExtractionType = ExtractionType.Transaction,
                ExtractedData = JsonSerializer.Serialize(extractionResult),
            };
            message.ChatExtraction = chatExtraction;

            var userPreferences = await _userPreferenceService.GetUserPreferenceByIdAsync(request.UserId);
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
                            //OccurredAt = item.OccurredAt ?? DateTimeOffset.Now,
                        };

                        var category = item.Category != null ?
                            await _context.Categories
                            .AsNoTracking()
                            .FirstOrDefaultAsync(e => e.Name == item.Category && e.UserId == request.UserId && !e.IsDeleted) :
                            await _categoryService.GetDefaultCategoryAsync(item.Type);

                        if (category == null)
                        {
                            category = await _categoryService.GetDefaultCategoryAsync(item.Type);
                        }

                        extractedTransaction.CategoryId = category.Id;
                        extractedTransaction.CurrencyCode = userPreferences.CurrencyCode;
                        extractedTransaction.ConfirmationMode = userPreferences.ConfirmationMode;
                        extractedTransaction.ConfirmationStatus = userPreferences.ConfirmationMode == ConfirmationMode.Auto ?
                            ConfirmationStatus.Confirmed :
                            ConfirmationStatus.Pending;

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
            await _context.SaveChangesAsync();

            if(userPreferences.ConfirmationMode == ConfirmationMode.Auto)
            {
                var transactions = new List<Transaction>();
                foreach(var item in chatExtraction.ExtractedTransactions)
                {
                    var transaction = Transaction.CreateFrom(item, request.UserId, request.WalletId, request.MessageId);
                    if(transaction != null)
                    {
                        transactions.Add(transaction);
                    }
                }

                var transactionDtoList = await _transactionService.CreateTransactionsAsync(request.UserId, request.WalletId, transactions);
            }

            await _mediator.Publish(new MessageProcessedNotification()
            {
                UserId = request.UserId,
                WalletId = request.WalletId,
                ChatThreadId = chatThreadId,
                SystemMessage = _mapper.Map<ChatMessageDto>(systemMsg),
                ExtractedTransactions = _mapper.Map<List<ExtractedTransactionDto>>(chatExtraction.ExtractedTransactions)
            });

            return Unit.Value;
        }
    }
}
