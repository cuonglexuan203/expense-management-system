using EMS.Application.Features.Transactions.Dtos;
using EMS.Core.Entities;

namespace EMS.Application.Features.Transactions.Services
{
    public interface ITransactionService
    {
        (Wallet Wallet, Transaction Transaction) ApplyTransactionToWalletAsync(Wallet wallet, Transaction transaction, CancellationToken cancellationToken = default);
        Task<TransactionDto> CreateTransactionAsync(string userId, int walletId, Transaction transaction, CancellationToken cancellationToken = default);
        Task<List<TransactionDto>> CreateTransactionsAsync(string userId, int walletId, List<Transaction> transactions, CancellationToken cancellationToken = default);
        Task<bool> HasSufficientBalanceAsync(int walletId, Transaction transaction, CancellationToken cancellationToken = default);
        bool HasSufficientBalance(Wallet wallet, Transaction transaction);
        bool HasSufficientBalance(Wallet wallet, Transaction transaction, out float newBalance);
        Task<TransactionDto?> GetTransactionByIdAsync(int transactionId, CancellationToken cancellationToken = default);
    }
}
