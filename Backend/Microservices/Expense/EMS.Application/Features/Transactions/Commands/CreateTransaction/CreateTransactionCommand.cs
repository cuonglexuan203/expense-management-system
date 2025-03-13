using AutoMapper;
using EMS.Application.Common.Exceptions;
using EMS.Application.Common.Interfaces.DbContext;
using EMS.Application.Common.Interfaces.Services;
using EMS.Application.Common.Utils;
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
        public string? Category { get; set; }
        public float Amount { get; set; }
        public TransactionType Type { get; set; }
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

        //
        private static readonly TimePeriod[] _walletSummaryPeriods = Enum.GetValues<TimePeriod>();

        public CreateTransactionCommandHandler(
            ILogger<CreateTransactionCommandHandler> logger,
            IApplicationDbContext context,
            ICurrentUserService user,
            IMapper mapper,
            IWalletService walletService,
            IDistributedCacheService distributedCacheService,
            ITransactionService transactionService)
        {
            _logger = logger;
            _context = context;
            _user = user;
            _mapper = mapper;
            _walletService = walletService;
            _distributedCacheService = distributedCacheService;
            _transactionService = transactionService;
        }

        public async Task<TransactionDto> Handle(CreateTransactionCommand request, CancellationToken cancellationToken)
        {
            string userId = _user.Id!;

            var wallet = await _context.Wallets
                .AsNoTracking()
                .FirstOrDefaultAsync(e => e.Id == request.WalletId && e.UserId == userId && !e.IsDeleted)
                ?? throw new NotFoundException($"Wallet with Id {request.WalletId} not found");

            var transaction = new Transaction
            {
                Name = request.Name,
                WalletId = request.WalletId,
                Amount = request.Amount,
                Type = request.Type,
                UserId = userId,
            };

            if (request.Category != null)
            {
                var category = await _context.Categories
                    .SingleOrDefaultAsync(e => 
                e.Name == request.Category && (e.UserId == userId || e.UserId == null) && !e.IsDeleted)
                ?? throw new NotFoundException($"Category with name {request.Category} not found");

                BadRequestException.ThrowIf(request.Type != category.FinancialFlowType,
                    $"Cannot use a {category.FinancialFlowType} category for a {request.Type} transaction");

                transaction.CategoryId = category.Id;
            }

            await _transactionService.CreateTransactionAsync(request.WalletId, transaction);

            _logger.LogInformation("Added a {Type} transaction: id {id}, wallet id {WalletId}, amount {Amount}, category {Category}",
                transaction.Type, transaction.Id, transaction.WalletId, transaction.Amount, request.Category);

            await CacheWalletBalanceSummariesAsync(request.WalletId);

            return _mapper.Map<TransactionDto>(transaction);
        }

        private async Task CacheWalletBalanceSummariesAsync(int walletId)
        {
            foreach(var value in _walletSummaryPeriods)
            {
                var walletSummary = await _walletService.GetWalletBalanceSummaryAsync(walletId, value);

                await _distributedCacheService.SetAsync(
                    CacheKeyGenerator.GenerateForUser(CacheKeyGenerator.QueryKeys.WalletByUser, _user.Id!, walletId, value), 
                    walletSummary);
            }
        }
    }
}
