using EMS.Application.Common.Exceptions;
using EMS.Application.Common.Interfaces.DbContext;
using EMS.Application.Common.Interfaces.Services;
using EMS.Core.Enums;
using EMS.Core.Exceptions;
using MediatR;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Logging;

namespace EMS.Application.Features.ExtractedTransactions.Commands.RejectExtractedTransaction
{
    public record RejectExtractedTransactionCommand(int ExtractedTransactionId, int WalletId) : IRequest<Unit>;

    public class RejectExtractedTransactionCommandHandler : IRequestHandler<RejectExtractedTransactionCommand, Unit>
    {
        private readonly ILogger<RejectExtractedTransactionCommandHandler> _logger;
        private readonly ICurrentUserService _userService;
        private readonly IApplicationDbContext _context;

        public RejectExtractedTransactionCommandHandler(
            ILogger<RejectExtractedTransactionCommandHandler> logger,
            ICurrentUserService userService,
            IApplicationDbContext context)
        {
            _logger = logger;
            _userService = userService;
            _context = context;
        }
        public async Task<Unit> Handle(RejectExtractedTransactionCommand request, CancellationToken cancellationToken)
        {
            var userId = _userService.Id!;

            try
            {
                var extractedTransaction = await _context.ExtractedTransactions
                    .FirstOrDefaultAsync(e => e.Id == request.ExtractedTransactionId && !e.IsDeleted)
                    ?? throw new NotFoundException($"Extracted Transaction with id {request.ExtractedTransactionId} not found");

                if (extractedTransaction.ConfirmationStatus != ConfirmationStatus.Pending)
                {
                    throw new InvalidTransactionOperationException($"Only transactions with a pending status can be rejected. Extracted Transaction ID: {request.ExtractedTransactionId}.");
                }

                extractedTransaction.ConfirmationStatus = ConfirmationStatus.Rejected;

                await _context.SaveChangesAsync();

                return Unit.Value;
            }
            catch (Exception)
            {
                _logger.LogError("An error occurred while confirming the pending transaction with id {Id}", request.ExtractedTransactionId);

                throw;
            }
        }
    }
}
