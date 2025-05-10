using AutoMapper;
using AutoMapper.QueryableExtensions;
using EMS.Application.Common.Exceptions;
using EMS.Application.Common.Extensions;
using EMS.Application.Common.Interfaces.DbContext;
using EMS.Application.Common.Interfaces.Services;
using EMS.Application.Common.Utils;
using EMS.Application.Features.Wallets.Dtos;
using EMS.Application.Features.Wallets.Queries.GetWalletSummary;
using EMS.Application.Features.Wallets.Services;
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
        private readonly IDistributedCacheService _distributedCacheService;
        private readonly IMapper _mapper;

        //
        private static readonly TimePeriod[] _walletSummaryPeriods = Enum.GetValues<TimePeriod>();

        public WalletService(
            ILogger<WalletService> logger,
            IApplicationDbContext context,
            ICurrentUserService currentUserService,
            IDistributedCacheService distributedCacheService,
            IMapper mapper)
        {
            _logger = logger;
            _context = context;
            _currentUserService = currentUserService;
            _distributedCacheService = distributedCacheService;
            _mapper = mapper;
        }

        public async Task<WalletBalanceSummary> GetWalletBalanceSummaryAsync(
            int walletId, 
            TimePeriod period, 
            DateTime? fromDate = null,
            DateTime? toDate = null,
            CancellationToken cancellationToken = default)
        {
            var summary = await GetWalletBalanceSummaryAsync(
                _currentUserService.Id!, 
                walletId, 
                period, 
                fromDate,
                toDate,
                cancellationToken);

            return summary;
        }

        public async Task<WalletBalanceSummary> GetWalletBalanceSummaryAsync(
            string userId, 
            int walletId, 
            TimePeriod period, 
            DateTime? fromDate = null,
            DateTime? toDate = null,
            CancellationToken cancellationToken = default)
        {
            var wallet = await _context.Wallets
                .AsNoTracking()
                .SingleOrDefaultAsync(e => e.UserId == userId && e.Id == walletId && !e.IsDeleted)
                ?? throw new NotFoundException($"Wallet with id {walletId} not found by user {userId}");

            var transactionQuery = _context.Transactions
                .AsNoTracking()
                .Where(e => e.WalletId == wallet.Id && !e.IsDeleted);

            if (fromDate.HasValue || toDate.HasValue)
            {
                if (fromDate.HasValue)
                {
                    transactionQuery = transactionQuery.Where(e => e.OccurredAt >= fromDate.Value);
                }
        
                if (toDate.HasValue)
                {
                    transactionQuery = transactionQuery.Where(e => e.OccurredAt <= toDate.Value);
                }
            }
            else
            {
                transactionQuery = transactionQuery.FilterTransactionsByPeriod(period);
            }

            var totalIncome = await transactionQuery
                .Where(e => e.Type == TransactionType.Income)
                .GroupBy(e => 1)
                .Select(g => new TransactionSummary(g.Sum(e => e.Amount), g.Count()))
                .SingleOrDefaultAsync() ?? new TransactionSummary(0, 0);

            var totalExpense = await transactionQuery
                .Where(e => e.Type == TransactionType.Expense)
                .GroupBy(e => 1)
                .Select(g => new TransactionSummary(g.Sum(e => e.Amount), g.Count()))
                .SingleOrDefaultAsync() ?? new TransactionSummary(0, 0);

            var result = new WalletBalanceSummary
            {
                Id = walletId,
                Name = wallet.Name,
                Balance = wallet.Balance,
                Description = wallet.Description,
                FilterPeriod = period,
                FromDate = fromDate,
                ToDate = toDate,
                Income = totalIncome,
                Expense = totalExpense,
            };

            return result;
        }

        public async Task<WalletDto?> GetWalletByIdAsync(int id, CancellationToken cancellationToken = default)
        {
            var userId = _currentUserService.Id;

            var walletDto = await _context.Wallets
                .AsNoTracking()
                .Where(e => e.Id == id && e.UserId == userId && !e.IsDeleted)
                .ProjectTo<WalletDto>(_mapper.ConfigurationProvider)
                .FirstOrDefaultAsync();

            return walletDto;
        }

        public async Task CacheWalletBalanceSummariesAsync(int walletId)
        {
            await CacheWalletBalanceSummariesAsync(_currentUserService.Id!, walletId);
        }

        public async Task CacheWalletBalanceSummariesAsync(string userId, int walletId)
        {
            foreach (var period in _walletSummaryPeriods)
            {
                var walletSummary = await GetWalletBalanceSummaryAsync(userId, walletId, period);
                await _distributedCacheService.SetAsync(
                    CacheKeyGenerator.GenerateForUser(CacheKeyGenerator.QueryKeys.WalletByUser, userId, walletId, period, "null", "null"), // FromDate: null, ToDate: null
                    walletSummary);
            }
        }
    }
}
