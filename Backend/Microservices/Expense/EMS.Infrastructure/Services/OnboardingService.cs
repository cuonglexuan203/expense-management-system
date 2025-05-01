using AutoMapper;
using EMS.Application.Common.Exceptions;
using EMS.Application.Common.Interfaces.DbContext;
using EMS.Application.Features.Categories.Dtos;
using EMS.Application.Features.Categories.Services;
using EMS.Application.Features.Onboarding.Commands;
using EMS.Application.Features.Onboarding.Services;
using EMS.Application.Features.Preferences.Dtos;
using EMS.Application.Features.Wallets.Dtos;
using EMS.Core.Entities;
using EMS.Core.Enums;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Logging;

namespace EMS.Infrastructure.Services
{
    public class OnboardingService : IOnboardingService
    {
        private readonly ILogger<CompleteUserOnboardingCommandHandler> _logger;
        private readonly IApplicationDbContext _context;
        private readonly ICategoryService _categoryService;
        private readonly IMapper _mapper;

        public OnboardingService(
            ILogger<CompleteUserOnboardingCommandHandler> logger,
            IApplicationDbContext context,
            ICategoryService categoryService,
            IMapper mapper)
        {
            _logger = logger;
            _context = context;
            _categoryService = categoryService;
            _mapper = mapper;
        }

        public async Task<UserOnboardingVm> CompleteUserOnboarding(
            string userId,
            string languageCodeStr,
            string currencyCodeStr,
            List<int> categoryIds,
            WalletDto wallet)
        {
            try
            {
                #region Setup user preferences
                var userPreference = await _context.UserPreferences
                    .FirstOrDefaultAsync(e => !e.IsDeleted && e.UserId == userId)
                    ?? throw new NotFoundException($"Can not find (default) user preferences of user ID {userId}.");

                if (userPreference.IsOnboardingCompleted)
                {
                    throw new InvalidOperationException($"User {userId} has already completed the onboarding process.");
                }

                if (Enum.TryParse<LanguageCode>(languageCodeStr, out var languageCode))
                {
                    userPreference.LanguageCode = languageCode;
                }

                if (Enum.TryParse<CurrencyCode>(currencyCodeStr, out var currencyCode))
                {
                    userPreference.CurrencyCode = currencyCode;
                }

                userPreference.IsOnboardingCompleted = true;

                _context.UserPreferences.Update(userPreference);
                #endregion

                #region Setup categories
                var defaultCategories = await _categoryService.GetDefaultCategoriesAsync();
                var defaultIncomeUnknownCategory = await _categoryService.GetUnknownCategoryAsync(TransactionType.Income);
                var defaultExpenseUnknownCategory = await _categoryService.GetUnknownCategoryAsync(TransactionType.Expense);

                var extendedCategorySet = categoryIds.ToHashSet();
                extendedCategorySet.Add(defaultIncomeUnknownCategory.Id);
                extendedCategorySet.Add(defaultExpenseUnknownCategory.Id);

                var categories = new List<Category>();
                foreach (var categoryId in extendedCategorySet)
                {
                    try
                    {
                        var defaultCategory = defaultCategories.FirstOrDefault(c => c.Id == categoryId)
                            ?? throw new NotFoundException($"Category ID {categoryId} not found");

                        var category = new Category
                        {
                            UserId = userId,
                            Name = defaultCategory.Name,
                            Type = CategoryType.Custom,
                            FinancialFlowType = defaultCategory.FinancialFlowType,
                            IconId = defaultCategory.IconId,
                        };

                        categories.Add(category);
                    }
                    catch (Exception ex)
                    {
                        _logger.LogError("An error while setup categories: {Msg}", ex.Message);
                    }
                }

                _context.Categories.AddRange(categories);
                #endregion

                #region Setup wallet
                var newWallet = new Wallet
                {
                    UserId = userId,
                    Name = wallet.Name,
                    Balance = wallet.Balance,
                    Description = wallet.Description,
                };

                _context.Wallets.Add(newWallet);
                #endregion

                #region Setup chat thread
                var chatThread = new ChatThread()
                {
                    UserId = userId,
                    Title = "Assistant",
                    Type = ChatThreadType.Assistant,
                    IsActive = true,
                };

                _context.ChatThreads.Add(chatThread);
                #endregion

                await _context.SaveChangesAsync();

                return new UserOnboardingVm(
                    _mapper.Map<UserPreferenceDto>(userPreference),
                    _mapper.Map<List<CategoryDto>>(categories),
                    _mapper.Map<WalletDto>(newWallet));
            }
            catch (Exception ex)
            {
                _logger.LogError("An error occurred while setup onboarding for user ID {UserId}: {Msg}",
                    userId,
                    ex.Message);

                throw;
            }
        }

        public async Task<bool> IsOnboardingCompleted(string userId)
        {
            var userPreferences = await _context.UserPreferences
                .AsNoTracking()
                .FirstOrDefaultAsync(e => !e.IsDeleted && e.UserId == userId)
                ?? throw new NotFoundException($"User preferences of user {userId} not found");

            return userPreferences.IsOnboardingCompleted;
        }
    }
}
