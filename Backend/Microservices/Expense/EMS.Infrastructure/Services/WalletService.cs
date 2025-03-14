using AutoMapper;
using AutoMapper.QueryableExtensions;
using EMS.Application.Common.Exceptions;
using EMS.Application.Common.Extensions;
using EMS.Application.Common.Interfaces.DbContext;
using EMS.Application.Common.Interfaces.Services;
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
        private readonly IMapper _mapper;

        public WalletService(
            ILogger<WalletService> logger,
            IApplicationDbContext context,
            ICurrentUserService currentUserService,
            IMapper mapper)
        {
            _logger = logger;
            _context = context;
            _currentUserService = currentUserService;
            _mapper = mapper;
        }

        public async Task<WalletBalanceSummary> GetWalletBalanceSummaryAsync(int walletId, TimePeriod period, CancellationToken cancellationToken = default)
        {
            var wallet = await _context.Wallets
                .AsNoTracking()
                .SingleOrDefaultAsync(e => e.UserId == _currentUserService.Id && e.Id == walletId && !e.IsDeleted)
                ?? throw new NotFoundException($"Wallet with id {walletId} not found by user {_currentUserService.Id}");

            var transactionQuery = _context.Transactions
            .Where(e => e.WalletId == wallet.Id && !e.IsDeleted)
            .FilterTransactionsByPeriod(period);

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
    }
}
