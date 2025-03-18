using AutoMapper;
using EMS.Application.Common.Exceptions;
using EMS.Application.Common.Interfaces.DbContext;
using EMS.Application.Common.Interfaces.Services;
using EMS.Application.Common.Utils;
using EMS.Application.Features.Categories.Services;
using EMS.Application.Features.Transactions.Dtos;
using EMS.Application.Features.Transactions.Services;
using EMS.Application.Features.Wallets.Services;
using EMS.Core.Entities;
using EMS.Core.Enums;
using MediatR;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Logging;

namespace EMS.Application.Features.Transactions.Commands.CreateTransaction
{
    public class CreateTransactionCommand : IRequest<TransactionDto>
    {
        public string Name { get; set; } = default!;
        public int WalletId { get; set; }
        public int? CategoryId { get; set; }
        public float Amount { get; set; }
        public TransactionType Type { get; set; }
        public DateTimeOffset? OccurredAt { get; set; } // Nullable because there are cases where the user may not remember the transaction time.
    }

    public class CreateTransactionCommandHandler : IRequestHandler<CreateTransactionCommand, TransactionDto>
    {
        private readonly ILogger<CreateTransactionCommandHandler> _logger;
        private readonly IApplicationDbContext _context;
        private readonly ICurrentUserService _user;
        private readonly IMapper _mapper;
        private readonly IWalletService _walletService;
        private readonly IDistributedCacheService _distributedCacheService;
        private readonly ITransactionService _transactionService;
        private readonly ICategoryService _categoryService;
        private readonly IUserPreferenceService _userPreferenceService;

        //
        private static readonly TimePeriod[] _walletSummaryPeriods = Enum.GetValues<TimePeriod>();

        public CreateTransactionCommandHandler(
            ILogger<CreateTransactionCommandHandler> logger,
            IApplicationDbContext context,
            ICurrentUserService user,
            IMapper mapper,
            IWalletService walletService,
            IDistributedCacheService distributedCacheService,
            ITransactionService transactionService,
            ICategoryService categoryService,
            IUserPreferenceService userPreferenceService)
        {
            _logger = logger;
            _context = context;
            _user = user;
            _mapper = mapper;
            _walletService = walletService;
            _distributedCacheService = distributedCacheService;
            _transactionService = transactionService;
            _categoryService = categoryService;
            _userPreferenceService = userPreferenceService;
        }

        public async Task<TransactionDto> Handle(CreateTransactionCommand request, CancellationToken cancellationToken)
        {
            string userId = _user.Id!;

            var wallet = await _context.Wallets
                .AsNoTracking()
                .FirstOrDefaultAsync(e => e.Id == request.WalletId && e.UserId == userId && !e.IsDeleted)
                ?? throw new NotFoundException($"Wallet with Id {request.WalletId} not found");

            var userPreference = await _userPreferenceService.GetUserPreferenceAsync();

            var transaction = new Transaction
            {
                Name = request.Name,
                WalletId = request.WalletId,
                UserId = userId,
                CurrencyCode = userPreference.CurrencyCode,
                Amount = request.Amount,
                Type = request.Type,
                OccurredAt = request.OccurredAt,
            };

            #region Add a new transaction into the category
            if (request.CategoryId != null)
            {
                var category = await _context.Categories
                .SingleOrDefaultAsync(e =>
                e.Id == request.CategoryId && e.UserId == userId && !e.IsDeleted)
                ?? throw new NotFoundException($"Category with id {request.CategoryId} not found");

                BadRequestException.ThrowIf(request.Type != category.FinancialFlowType,
                    $"Cannot use a {category.FinancialFlowType} category for a {request.Type} transaction");

                transaction.CategoryId = category.Id;
            }
            else
            {
                var defaultCategory = await _categoryService.GetDefaultCategoryAsync(request.Type);
                transaction.CategoryId = defaultCategory.Id;
            }
            #endregion

            await _transactionService.CreateTransactionAsync(request.WalletId, transaction);

            _logger.LogInformation("Added a {Type} transaction: id {id}, wallet id {WalletId}, amount {Amount}, category id {Category}",
                transaction.Type, transaction.Id, transaction.WalletId, transaction.Amount, transaction.CategoryId);

            await CacheWalletBalanceSummariesAsync(request.WalletId);

            return _mapper.Map<TransactionDto>(transaction);
        }

        private async Task CacheWalletBalanceSummariesAsync(int walletId)
        {
            foreach (var value in _walletSummaryPeriods)
            {
                var walletSummary = await _walletService.GetWalletBalanceSummaryAsync(walletId, value);

                await _distributedCacheService.SetAsync(
                    CacheKeyGenerator.GenerateForUser(CacheKeyGenerator.QueryKeys.WalletByUser, _user.Id!, walletId, value),
                    walletSummary);
            }
        }
    }
}
