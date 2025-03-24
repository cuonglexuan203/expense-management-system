using AutoMapper;
using EMS.Application.Common.Exceptions;
using EMS.Application.Common.Interfaces.DbContext;
using EMS.Application.Features.Transactions.Dtos;
using EMS.Application.Features.Transactions.Services;
using EMS.Core.Entities;
using EMS.Core.Enums;
using EMS.Core.Exceptions;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Logging;

namespace EMS.Infrastructure.Services
{
    public class TransactionService : ITransactionService
    {
        private readonly ILogger<TransactionService> _logger;
        private readonly IApplicationDbContext _context;
        private readonly IMapper _mapper;

        public TransactionService(
            ILogger<TransactionService> logger,
            IApplicationDbContext context,
            IMapper mapper)
        {
            _logger = logger;
            _context = context;
            _mapper = mapper;
        }

        public (Wallet Wallet, Transaction Transaction) ApplyTransactionToWalletAsync(
            Wallet wallet,
            Transaction transaction,
            CancellationToken cancellationToken = default)
        {
            InvalidTransactionOperationException.ThrowIf(
                !HasSufficientBalance(wallet, transaction, out var newBalance),
                $"Wallet with Id {wallet.Id} has insufficient balance for transaction amount {transaction.Amount}");

            transaction.WalletId = wallet.Id;

            wallet.Balance = newBalance;

            return (wallet, transaction);
        }

        public async Task<TransactionDto> CreateTransactionAsync(string userId, int walletId, Transaction transaction, CancellationToken cancellationToken = default)
        {
            var wallet = await _context.Wallets
                .FirstOrDefaultAsync(e => e.UserId == userId && e.Id == walletId && !e.IsDeleted)
                ?? throw new NotFoundException($"Wallet with Id {walletId} not found");

            transaction.UserId = userId;
            ApplyTransactionToWalletAsync(wallet, transaction, cancellationToken);

            _context.Transactions.Add(transaction);
            await _context.SaveChangesAsync();

            return _mapper.Map<TransactionDto>(transaction);
        }

        public async Task<List<TransactionDto>> CreateTransactionsAsync(string userId, int walletId, List<Transaction> transactions, CancellationToken cancellationToken = default)
        {
            var wallet = await _context.Wallets
                .FirstOrDefaultAsync(e => e.UserId == userId && e.Id == walletId && !e.IsDeleted)
                ?? throw new NotFoundException($"Wallet with Id {walletId} not found");

            foreach (var transaction in transactions)
            {
                transaction.UserId = userId;
                ApplyTransactionToWalletAsync(wallet, transaction, cancellationToken);
            }

            _context.Transactions.AddRange(transactions);
            await _context.SaveChangesAsync();

            return _mapper.Map<List<TransactionDto>>(transactions);
        }

        public async Task<bool> HasSufficientBalanceAsync(int walletId, Transaction transaction, CancellationToken cancellationToken = default)
        {
            var wallet = await _context.Wallets
                .AsNoTracking()
                .Where(e => e.Id == walletId && !e.IsDeleted)
                .Select(e => new { e.Balance })
                .FirstOrDefaultAsync()
                ?? throw new NotFoundException($"Wallet with Id {walletId} not found");

            return CalculateWalletBalance(wallet.Balance, transaction) > 0;
        }
        public bool HasSufficientBalance(Wallet wallet, Transaction transaction)
        {
            return HasSufficientBalance(wallet, transaction, out var newBalance);
        }

        public bool HasSufficientBalance(Wallet wallet, Transaction transaction, out float newBalance)
        {
            newBalance = CalculateWalletBalance(wallet.Balance, transaction);
            return newBalance >= 0;
        }

        private float CalculateWalletBalance(Wallet wallet, Transaction transaction)
        => CalculateWalletBalance(wallet.Balance, transaction);

        private float CalculateWalletBalance(float walletBalance, Transaction transaction)
        => walletBalance + transaction.Type switch
        {
            TransactionType.Expense => -transaction.Amount,
            TransactionType.Income => transaction.Amount,
            _ => 0,
        };

        public async Task<TransactionDto?> GetTransactionByIdAsync(int transactionId, CancellationToken cancellationToken = default)
        {
            var transaction = await _context.Transactions
                .Include(e => e.Category)
                .Include(e => e.Wallet)
                .AsNoTracking()
                .FirstOrDefaultAsync(e => e.Id == transactionId && !e.IsDeleted);

            return _mapper.Map<TransactionDto>(transaction);
        }
    }
}
