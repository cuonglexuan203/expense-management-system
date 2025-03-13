using EMS.Application.Common.Exceptions;
using EMS.Application.Features.Transactions.Dtos;
using EMS.Application.Features.Transactions.Services;
using MediatR;
using Microsoft.Extensions.Logging;

namespace EMS.Application.Features.Transactions.Queries.GetTransaction
{
    public record GetTransactionQuery(int TransactionId) : IRequest<TransactionDto>;

    public class GetTransactionQueryHandler : IRequestHandler<GetTransactionQuery, TransactionDto>
    {
        private readonly ILogger<GetTransactionQueryHandler> _logger;
        private readonly ITransactionService _transactionService;

        public GetTransactionQueryHandler(ILogger<GetTransactionQueryHandler> logger, ITransactionService transactionService)
        {
            _logger = logger;
            _transactionService = transactionService;
        }
        public async Task<TransactionDto> Handle(GetTransactionQuery request, CancellationToken cancellationToken)
        {
            var transaction = await _transactionService.GetTransaction(request.TransactionId)
                ?? throw new NotFoundException($"Transaction with id {request.TransactionId} not found");

            return transaction;
        }
    }
}
