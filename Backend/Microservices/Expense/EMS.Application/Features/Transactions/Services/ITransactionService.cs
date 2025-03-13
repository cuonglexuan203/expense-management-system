using EMS.Application.Features.Transactions.Commands.Dtos;
using EMS.Core.Entities;

namespace EMS.Application.Features.Transactions.Services
{
    public interface ITransactionService
    {
        Task<TransactionDto> CreateTransactionAsync(int walletId, Transaction transaction, CancellationToken cancellationToken = default);
        Task<bool> HasSufficientBalance(int walletId, Transaction transaction, CancellationToken cancellationToken = default);
    }
}
