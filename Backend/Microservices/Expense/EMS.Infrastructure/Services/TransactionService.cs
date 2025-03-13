using AutoMapper;
using EMS.Application.Common.Exceptions;
using EMS.Application.Common.Interfaces.DbContext;
using EMS.Application.Features.Transactions.Commands.Dtos;
using EMS.Application.Features.Transactions.Services;
using EMS.Core.Entities;
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

        public TransactionService(ILogger<TransactionService> logger, IApplicationDbContext context, IMapper mapper)
        {
            _logger = logger;
            _context = context;
            _mapper = mapper;
        }

        public async Task<TransactionDto> CreateTransactionAsync(int walletId, Transaction transaction, CancellationToken cancellationToken = default)
        {
            InvalidTransactionOperationException.ThrowIf(
                !await HasSufficientBalance(walletId, transaction, cancellationToken),
                $"Wallet {walletId} has insufficient balance for transaction amount {transaction.Amount}");

            transaction.WalletId = walletId;

            var wallet = await _context.Wallets
                .FirstOrDefaultAsync(e => e.Id == walletId && !e.IsDeleted);
            wallet!.Balance += transaction.Type switch
            {
                Core.Enums.TransactionType.Expense => -transaction.Amount,
                Core.Enums.TransactionType.Income => transaction.Amount,
                _ => 0,
            };

            _context.Transactions.Add(transaction);
            await _context.SaveChangesAsync();

            return _mapper.Map<TransactionDto>(transaction);
        }

        public async Task<bool> HasSufficientBalance(int walletId, Transaction transaction, CancellationToken cancellationToken = default)
        {
            var wallet = await _context.Wallets
                .AsNoTracking()
                .Where(e => e.Id == walletId && !e.IsDeleted)
                .Select(e => new { e.Balance })
                .FirstOrDefaultAsync()
                ?? throw new NotFoundException($"Wallet with Id {walletId} not found");

            return wallet.Balance - transaction.Amount >= 0;
        }
    }
}
