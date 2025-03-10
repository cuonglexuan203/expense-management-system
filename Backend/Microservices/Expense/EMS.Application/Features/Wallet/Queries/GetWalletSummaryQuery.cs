using EMS.Application.Common.Exceptions;
using EMS.Application.Common.Interfaces.DbContext;
using EMS.Application.Common.Interfaces.Services;
using EMS.Core.Entities;
using EMS.Core.Enums;
using MediatR;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Logging;

namespace EMS.Application.Features.Wallet.Queries
{
    public record GetWalletSummaryQuery(int WalletId, BalanceFilterPeriod period = BalanceFilterPeriod.AllTime) : IRequest<WalletBalanceSummary>;

    public class GetWalletSummaryQueryHandler : IRequestHandler<GetWalletSummaryQuery, WalletBalanceSummary>
    {
        private readonly ILogger<GetWalletSummaryQuery> _logger;
        private readonly IApplicationDbContext _context;
        private readonly ICurrentUserService _currentUserService;

        public GetWalletSummaryQueryHandler(ILogger<GetWalletSummaryQuery> logger, IApplicationDbContext context, ICurrentUserService currentUserService)
        {
            _logger = logger;
            _context = context;
            _currentUserService = currentUserService;
        }

        public async Task<WalletBalanceSummary> Handle(GetWalletSummaryQuery request, CancellationToken cancellationToken)
        {
            var wallet = await _context.Wallets
                .Where(e => e.UserId == _currentUserService.Id && e.Id == request.WalletId && !e.IsDeleted)
                .AsNoTracking()
                .FirstOrDefaultAsync() ?? throw new NotFoundException($"Wallet with id {request.WalletId} not found by user {_currentUserService.Id}");

            var transactionQuery = _context.Transactions
                .Where(e => e.WalletId == wallet.Id && !e.IsDeleted);

            transactionQuery = FilterTransactionsByPeriod(transactionQuery, request.period);

            var totalIncome = await transactionQuery
                .Where(e => e.Type == TransactionType.Income)
                .GroupBy(e => 1)
                .Select(g => new TransactionSummary(g.Sum(e => e.Amount), g.Count()))
                .FirstOrDefaultAsync();

            var totalExpense = await transactionQuery
                .Where(e => e.Type == TransactionType.Expense)
                .GroupBy(e => 1)
                .Select(g => new TransactionSummary(g.Sum(e => e.Amount), g.Count()))
                .FirstOrDefaultAsync();

            var result = new WalletBalanceSummary
            {
                WalletId = request.WalletId,
                Name = wallet.Name,
                Balance = wallet.Balance,
                Description = wallet.Description,
                FilterPeriod = request.period,
                Income = totalIncome,
                Expense = totalExpense,
            };

            return result;
        }

        private IQueryable<Transaction> FilterTransactionsByPeriod(IQueryable<Transaction> query, BalanceFilterPeriod period)
        {
            var now = DateTimeOffset.UtcNow;
            return period switch
            {
                BalanceFilterPeriod.CurrentWeek => query.Where(e => e.CreatedAt > GetStartDateOfWeek(now)),
                BalanceFilterPeriod.CurrentMonth => query.Where(e => e.CreatedAt > new DateTimeOffset(now.Year, now.Month, 1, 0, 0, 0, TimeSpan.Zero)),
                BalanceFilterPeriod.CurrentYear => query.Where(e => e.CreatedAt > new DateTimeOffset(now.Year, 1, 1, 0, 0, 0, TimeSpan.Zero)),
                BalanceFilterPeriod.AllTime => query,
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
