using EMS.Application.Common.Exceptions;
using EMS.Application.Common.Interfaces.DbContext;
using EMS.Application.Features.Transactions.Dtos;
using EMS.Application.Features.Transactions.Services;
using EMS.Application.Features.Wallets.Services;
using EMS.Core.Entities;
using EMS.Core.Enums;
using EMS.Core.Exceptions;
using MediatR;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Logging;

namespace EMS.Application.Features.AiTools.Commands.ConfirmExtractedTransactions
{
    public record ConfirmExtractedTransactionsCommand(string UserId, int WalletId, int MessageId) : IRequest<List<TransactionDto>>;

    public class ConfirmExtractedTransactionsCommandHandler : IRequestHandler<ConfirmExtractedTransactionsCommand, List<TransactionDto>>
    {
        private readonly ILogger<ConfirmExtractedTransactionsCommandHandler> _logger;
        private readonly IApplicationDbContext _context;
        private readonly ITransactionService _transactionService;
        private readonly IWalletService _walletService;

        public ConfirmExtractedTransactionsCommandHandler(
            ILogger<ConfirmExtractedTransactionsCommandHandler> logger,
            IApplicationDbContext context,
            ITransactionService transactionService,
            IWalletService walletService)
        {
            _logger = logger;
            _context = context;
            _transactionService = transactionService;
            _walletService = walletService;
        }
        public async Task<List<TransactionDto>> Handle(ConfirmExtractedTransactionsCommand request, CancellationToken cancellationToken)
        {
            try
            {
                var wallet = await _context.Wallets
                    .AsNoTracking()
                    .Where(e => !e.IsDeleted && e.UserId == request.UserId && e.Id == e.Id)
                    .FirstOrDefaultAsync()
                    ?? throw new NotFoundException($"Wallet with Id {request.WalletId} not found.");

                //var message = await _context.ChatMessages
                //    .Where(e => !e.IsDeleted && e.Id == request.MessageId)
                //    .FirstOrDefaultAsync()
                //    ?? throw new NotFoundException($"Message with Id {request.MessageId} not found.");

                var extractedTransactions = await _context.ExtractedTransactions
                    .Where(e => !e.IsDeleted 
                        && e.ConfirmationStatus == ConfirmationStatus.Pending
                        && !e.ChatExtraction.ChatMessage.IsDeleted
                        && e.ChatExtraction.ChatMessage.Id == request.MessageId)
                    .ToListAsync();

                if (!extractedTransactions.Any())
                {
                    throw new InvalidTransactionOperationException($"Message {request.MessageId} do not have any pending transaction");
                }

                var transactions = new List<Transaction>();
                foreach (var item in extractedTransactions)
                {
                    item.ConfirmationStatus = ConfirmationStatus.Confirmed;
                    var transaction = Transaction.CreateFrom(item, request.UserId, request.WalletId, request.MessageId);

                    if (transaction != null)
                    {
                        transactions.Add(transaction);
                    }
                }

                var transactionDtoList = await _transactionService.CreateTransactionsAsync(request.UserId, request.WalletId, transactions);

                await _walletService.CacheWalletBalanceSummariesAsync(request.UserId, request.WalletId);

                return transactionDtoList;
            }
            catch
            {
                _logger.LogError("An error occurred while confirming extracted transactions of message {MsgId}", request.MessageId);
                throw;
            }
        }
    }
}
