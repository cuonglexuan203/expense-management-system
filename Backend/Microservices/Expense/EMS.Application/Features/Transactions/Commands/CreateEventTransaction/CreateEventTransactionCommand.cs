using AutoMapper;
using EMS.Application.Common.Exceptions;
using EMS.Application.Common.Interfaces.DbContext;
using EMS.Application.Common.Interfaces.Services;
using EMS.Application.Features.Categories.Services;
using EMS.Application.Features.Transactions.Dtos;
using EMS.Application.Features.Transactions.Services;
using EMS.Application.Features.Wallets.Services;
using EMS.Core.Entities;
using EMS.Core.Enums;
using MediatR;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Logging;

namespace EMS.Application.Features.Transactions.Commands.CreateEventTransaction
{
    public record CreateEventTransactionCommand(
        string UserId,
        string Name,
        int WalletId,
        int? CategoryId,
        float Amount,
        TransactionType Type,
        DateTimeOffset? OccurredAt) : IRequest<TransactionDto>;

    public class CreateEventTransactionCommandHandler : IRequestHandler<CreateEventTransactionCommand, TransactionDto>
    {
        private readonly ILogger<CreateEventTransactionCommandHandler> _logger;
        private readonly IApplicationDbContext _context;
        private readonly IMapper _mapper;
        private readonly IWalletService _walletService;
        private readonly ITransactionService _transactionService;
        private readonly ICategoryService _categoryService;
        private readonly IUserPreferenceService _userPreferenceService;

        public CreateEventTransactionCommandHandler(
            ILogger<CreateEventTransactionCommandHandler> logger,
            IApplicationDbContext context,
            IMapper mapper,
            IWalletService walletService,
            ITransactionService transactionService,
            ICategoryService categoryService,
            IUserPreferenceService userPreferenceService)
        {
            _logger = logger;
            _context = context;
            _mapper = mapper;
            _walletService = walletService;
            _transactionService = transactionService;
            _categoryService = categoryService;
            _userPreferenceService = userPreferenceService;
        }
        public async Task<TransactionDto> Handle(CreateEventTransactionCommand request, CancellationToken cancellationToken)
        {
            string userId = request.UserId;

            var wallet = await _context.Wallets
                .AsNoTracking()
                .FirstOrDefaultAsync(e => e.Id == request.WalletId && e.UserId == userId && !e.IsDeleted)
                ?? throw new NotFoundException($"Wallet with Id {request.WalletId} not found");

            var userPreference = await _userPreferenceService.GetUserPreferenceByUserIdAsync(userId);

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

            #region Link transaction to category
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
                var defaultCategory = await _categoryService.GetUnknownCategoryAsync(userId, request.Type);
                transaction.CategoryId = defaultCategory.Id;
            }
            #endregion

            await _transactionService.CreateTransactionAsync(userId, request.WalletId, transaction);

            _logger.LogInformation("Added a {Type} transaction: id {id}, wallet id {WalletId}, amount {Amount}, category id {Category}",
                transaction.Type, transaction.Id, transaction.WalletId, transaction.Amount, transaction.CategoryId);

            await _walletService.CacheWalletBalanceSummariesAsync(userId, request.WalletId);

            return _mapper.Map<TransactionDto>(transaction);
        }
    }
}
