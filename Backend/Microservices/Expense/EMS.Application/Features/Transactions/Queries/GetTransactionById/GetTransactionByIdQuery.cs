using EMS.Application.Common.Exceptions;
using EMS.Application.Features.Transactions.Dtos;
using EMS.Application.Features.Transactions.Services;
using MediatR;
using Microsoft.Extensions.Logging;

namespace EMS.Application.Features.Transactions.Queries.GetTransactionById
{
    public record GetTransactionByIdQuery(int TransactionId) : IRequest<TransactionDto>;

    public class GetTransactionByIdQueryHandler : IRequestHandler<GetTransactionByIdQuery, TransactionDto>
    {
        private readonly ILogger<GetTransactionByIdQueryHandler> _logger;
        private readonly ITransactionService _transactionService;

        public GetTransactionByIdQueryHandler(ILogger<GetTransactionByIdQueryHandler> logger, ITransactionService transactionService)
        {
            _logger = logger;
            _transactionService = transactionService;
        }
        public async Task<TransactionDto> Handle(GetTransactionByIdQuery request, CancellationToken cancellationToken)
        {
            var transaction = await _transactionService.GetTransactionByIdAsync(request.TransactionId)
                ?? throw new NotFoundException($"Transaction with id {request.TransactionId} not found");

            return transaction;
        }
    }
}
