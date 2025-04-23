using EMS.Application.Common.Exceptions;
using EMS.Application.Common.Interfaces.DbContext;
using EMS.Application.Common.Interfaces.Services;
using EMS.Application.Features.Transactions.Dtos;
using EMS.Application.Features.Transactions.Services;
using EMS.Application.Features.Wallets.Services;
using EMS.Core.Entities;
using EMS.Core.Enums;
using EMS.Core.Exceptions;
using MediatR;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Logging;

namespace EMS.Application.Features.ExtractedTransactions.Commands.ConfirmExtractedTransaction
{
    // REVIEW: Saving ExtractedTransaction along with wallet id -> this command only needs pending transaction id
    public record ConfirmExtractedTransactionCommand(int ExtractedTransactionId, int WalletId) : IRequest<TransactionDto>;

    public class ConfirmExtractedTransactionCommandHandler : IRequestHandler<ConfirmExtractedTransactionCommand, TransactionDto>
    {
        private readonly ILogger<ConfirmExtractedTransactionCommandHandler> _logger;
        private readonly IApplicationDbContext _context;
        private readonly ICurrentUserService _userService;
        private readonly ITransactionService _transactionService;
        private readonly IWalletService _walletService;

        public ConfirmExtractedTransactionCommandHandler(
            ILogger<ConfirmExtractedTransactionCommandHandler> logger,
            IApplicationDbContext context,
            ICurrentUserService userService,
            ITransactionService transactionService,
            IWalletService walletService)
        {
            _logger = logger;
            _context = context;
            _userService = userService;
            _transactionService = transactionService;
            _walletService = walletService;
        }

        public async Task<TransactionDto> Handle(ConfirmExtractedTransactionCommand request, CancellationToken cancellationToken)
        {
            var userId = _userService.Id!;

            try
            {
                var extractedTransaction = await _context.ExtractedTransactions
                    .Include(x => x.ChatExtraction)
                    .ThenInclude(x => x.ChatMessage)
                    .FirstOrDefaultAsync(e => e.Id == request.ExtractedTransactionId && !e.IsDeleted)
                    ?? throw new NotFoundException($"Pending transaction with id {request.ExtractedTransactionId} not found");

                if (extractedTransaction.ConfirmationStatus == ConfirmationStatus.Confirmed)
                {
                    throw new InvalidTransactionOperationException($"Pending transaction with ID {request.ExtractedTransactionId} is already confirmed.");
                }

                extractedTransaction.ConfirmationStatus = ConfirmationStatus.Confirmed;
                var transaction = Transaction.CreateFrom(extractedTransaction, userId, request.WalletId, extractedTransaction?.ChatExtraction?.ChatMessage.Id);

                if (transaction == null)
                {
                    throw new InvalidTransactionOperationException($"Cannot confirm the pending transaction with ID {request.ExtractedTransactionId}.");
                }

                var transactionDto = await _transactionService.CreateTransactionAsync(userId, request.WalletId, transaction);

                await _walletService.CacheWalletBalanceSummariesAsync(request.WalletId);

                return transactionDto;

            }
            catch (Exception)
            {
                _logger.LogError("An error occurred while confirming the pending transaction with id {Id}", request.ExtractedTransactionId);

                throw;
            }
        }
    }
}
