using EMS.Application.Common.Exceptions;
using EMS.Application.Common.Interfaces.DbContext;
using EMS.Application.Common.Interfaces.Services;
using EMS.Application.Features.Wallets.Queries.GetWalletSummary;
using EMS.Application.Features.Wallets.Services;
using EMS.Core.Entities;
using EMS.Core.Enums;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Logging;

namespace EMS.Infrastructure.Services
{
    public class WalletService : IWalletService
    {
        private readonly ILogger<WalletService> _logger;
        private readonly IApplicationDbContext _context;
        private readonly ICurrentUserService _currentUserService;

        public WalletService(ILogger<WalletService> logger, IApplicationDbContext context, ICurrentUserService currentUserService)
        {
            _logger = logger;
            _context = context;
            _currentUserService = currentUserService;
        }

        public async Task<WalletBalanceSummary> GetWalletBalanceSummaryAsync(int walletId, WalletSummaryPeriod period, CancellationToken cancellationToken = default)
        {
            var wallet = await _context.Wallets
                .AsNoTracking()
                .SingleOrDefaultAsync(e => e.UserId == _currentUserService.Id && e.Id == walletId && !e.IsDeleted)
                ?? throw new NotFoundException($"Wallet with id {walletId} not found by user {_currentUserService.Id}");

            var transactionQuery = _context.Transactions
            .Where(e => e.WalletId == wallet.Id && !e.IsDeleted);

            transactionQuery = FilterTransactionsByPeriod(transactionQuery, period);

            var totalIncome = await transactionQuery
                .Where(e => e.Type == TransactionType.Income)
                .GroupBy(e => 1)
                .Select(g => new TransactionSummary(g.Sum(e => e.Amount), g.Count()))
                .SingleOrDefaultAsync();

            var totalExpense = await transactionQuery
                .Where(e => e.Type == TransactionType.Expense)
                .GroupBy(e => 1)
                .Select(g => new TransactionSummary(g.Sum(e => e.Amount), g.Count()))
                .SingleOrDefaultAsync();

            var result = new WalletBalanceSummary
            {
                WalletId = walletId,
                Name = wallet.Name,
                Balance = wallet.Balance,
                Description = wallet.Description,
                FilterPeriod = period,
                Income = totalIncome,
                Expense = totalExpense,
            };

            return result;
        }

        private IQueryable<Transaction> FilterTransactionsByPeriod(IQueryable<Transaction> query, WalletSummaryPeriod period)
        {
            var now = DateTimeOffset.UtcNow;
            return period switch
            {
                WalletSummaryPeriod.CurrentWeek => query.Where(e => e.CreatedAt > GetStartDateOfWeek(now)),
                WalletSummaryPeriod.CurrentMonth => query.Where(e => e.CreatedAt > new DateTimeOffset(now.Year, now.Month, 1, 0, 0, 0, TimeSpan.Zero)),
                WalletSummaryPeriod.CurrentYear => query.Where(e => e.CreatedAt > new DateTimeOffset(now.Year, 1, 1, 0, 0, 0, TimeSpan.Zero)),
                WalletSummaryPeriod.AllTime => query,
                _ => throw new ArgumentOutOfRangeException(nameof(period), period, null),
            };
        }

        private DateTimeOffset GetStartDateOfWeek(DateTimeOffset dt)
        {
            var diff = (7 + (dt.DayOfWeek - DayOfWeek.Monday)) % 7;

            return new DateTimeOffset(dt.DateTime.AddDays(-diff).Date, dt.Offset);

        }
    }
}
