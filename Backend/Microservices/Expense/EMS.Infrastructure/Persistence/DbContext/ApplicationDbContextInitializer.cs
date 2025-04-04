using EMS.Application.Common.Extensions;
using EMS.Application.Common.Interfaces.Services;
using EMS.Application.Features.Chats.Common.Services;
using EMS.Core.Constants;
using EMS.Infrastructure.Persistence.Seed;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Logging;

namespace EMS.Infrastructure.Persistence.DbContext
{
    public class ApplicationDbContextInitializer
    {
        private readonly ILogger<ApplicationDbContextInitializer> _logger;
        private readonly ApplicationDbContext _context;
        private readonly IIdentityService _identityService;
        private readonly IUserPreferenceService _userPreferenceService;
        private readonly IChatThreadService _chatThreadService;
        private readonly IApiKeyService _apiKeyService;

        public ApplicationDbContextInitializer(
            ILogger<ApplicationDbContextInitializer> logger,
            ApplicationDbContext context,
            IIdentityService identityService,
            IUserPreferenceService userPreferenceService,
            IChatThreadService chatThreadService,
            IApiKeyService apiKeyService)
        {
            _logger = logger;
            _context = context;
            _identityService = identityService;
            _userPreferenceService = userPreferenceService;
            _chatThreadService = chatThreadService;
            _apiKeyService = apiKeyService;
        }

        public async Task InitializeAsync()
        {
            try
            {
                _logger.LogStateInfo(AppStates.RunningMigrations, $"Migrating database: {_context.GetType().FullName}");
                await _context.Database.MigrateAsync();
            }
            catch (Exception ex)
            {
                _logger.LogStateError(ex, AppStates.RunningMigrations, "An error occurred while seeding the database.");
                throw;
            }
        }

        public async Task SeedAsync()
        {
            try
            {
                _logger.LogStateInfo(AppStates.SeedingData, $"Seeding database: {_context.GetType().FullName}");
                await TrySeedAsync();
                _logger.LogStateInfo(AppStates.SeedingData, $"Completed seeding database: {_context.GetType().FullName}");
            }
            catch (Exception ex)
            {
                _logger.LogStateError(ex, AppStates.SeedingData, "An error occurred while seeding the database.");
                throw;
            }
        }

        public async Task TrySeedAsync()
        {
            #region Add default system settings
            if (!_context.SystemSettings.Any())
            {
                var defaultSystemSettings = DefaultSeedData.GetDefaultSystemSettings();
                _context.SystemSettings.AddRange(defaultSystemSettings);
                _logger.LogStateInfo(AppStates.SeedingData, $"Added {defaultSystemSettings.Length} default system settings.");
            }
            #endregion

            #region Add default categories
            if (!_context.Categories.Any())
            {
                var defaultCategories = DefaultSeedData.GetDefaultCategories();
                _context.Categories.AddRange(defaultCategories);
                _logger.LogStateInfo(AppStates.SeedingData, $"Added {defaultCategories.Length} default categories.");
            }
            #endregion

            #region Add default currencies
            if (!_context.Currencies.Any())
            {
                var defaultCurrencies = DefaultSeedData.GetDefaultCurrencies();
                _context.Currencies.AddRange(defaultCurrencies);
                _logger.LogStateInfo(AppStates.SeedingData, $"Added {defaultCurrencies.Length} default currencies.");
            }
            #endregion

            #region Add default API Keys
            if (!_context.ApiKeys.Any())
            {
                var defaultApiKeys = await _apiKeyService.CreateApiKeysAsync(DefaultSeedData.GetDefaultApiKeys(), null);

                _logger.LogStateInfo(AppStates.SeedingData,
                    $"Added {defaultApiKeys.Count()} default API Keys: {string.Join(", ", defaultApiKeys.Select(ak => ak.Name))}");
            }
            #endregion

            #region Add default currency slangs
            if (!_context.CurrencySlangs.Any())
            {
                var defaultCurrencySlangs = DefaultSeedData.GetDefaultCurrencySlangs();
                _context.CurrencySlangs.AddRange(defaultCurrencySlangs);
                _logger.LogStateInfo(AppStates.SeedingData, $"Added {defaultCurrencySlangs.Length} default currency slangs.");
            }
            #endregion

            if (!_context.Roles.Any())
            {
                #region Add default roles
                var defaultRoles = DefaultSeedData.GetDefaultRoles();
                foreach (var role in defaultRoles)
                {
                    var result = await _identityService.CreateRoleAsync(role);

                    if (!result.Succeeded)
                    {
                        _logger.LogError("Failed to seed the role {0}: {1}", role, string.Join(", ", result.Errors!));
                    }
                }
                _logger.LogStateInfo(AppStates.SeedingData, $"Added default roles: {string.Join(", ", defaultRoles)}");
                #endregion

                #region Add default users
                foreach (var user in DefaultSeedData.GetDefaultUsers())
                {
                    var (result, userId) = await _identityService.CreateUserAsync(user.UserName, user.Pwd);

                    if (!result.Succeeded)
                    {
                        _logger.LogError("Failed to seed the user {0}: {1}", user.UserName, string.Join(", ", result.Errors!));
                        continue;
                    }

                    await _identityService.AddToRoleAsync(userId, user.Role);

                    _logger.LogStateInfo(AppStates.SeedingData, $"Added a default user: userName {user.UserName}, role {user.Role}");

                    await _userPreferenceService.CreateUserPreferencesAsync(userId);
                    await _chatThreadService.CreateDefaultChatThreadsAsync(userId);
                }
                #endregion
            }

            await _context.SaveChangesAsync();
        }
    }
}