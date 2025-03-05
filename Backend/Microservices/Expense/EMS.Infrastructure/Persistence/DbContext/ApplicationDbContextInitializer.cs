using EMS.Application.Common.Interfaces.Services;
using EMS.Core.Constants;
using EMS.Core.Entities;
using EMS.Core.Enums;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Logging;

namespace EMS.Infrastructure.Persistence.DbContext
{
    public class ApplicationDbContextInitializer
    {
        private readonly ILogger<ApplicationDbContextInitializer> _logger;
        private readonly ApplicationDbContext _context;
        private readonly IIdentityService _identityService;

        public ApplicationDbContextInitializer(ILogger<ApplicationDbContextInitializer> logger, ApplicationDbContext context, IIdentityService identityService)
        {
            _logger = logger;
            _context = context;
            _identityService = identityService;
        }

        public async Task InitializeAsync()
        {
            try
            {
                _logger.LogInformation("...Migrating database: {dbName}", _context.GetType().FullName);
                await _context.Database.MigrateAsync();
            }
            catch (Exception ex)
            {
                _logger.LogError("An error occurred while initializing the database: {msg}", ex.Message);
                throw;
            }
        }

        public async Task SeedAsync()
        {
            try
            {
                _logger.LogInformation("...Seeding the database: {dbName}.", _context.GetType().FullName);
                await TrySeedAsync();
            }
            catch
            {
                _logger.LogError("An error occurred while seeding the database.");
                throw;
            }
        }

        public async Task TrySeedAsync()
        {
            if (!_context.Roles.Any())
            {
                #region Add default roles
                var roles = new[]
                {
                    Roles.Administrator,
                    Roles.User
                };

                foreach (var role in roles)
                {
                    var result = await _identityService.CreateRoleAsync(role);

                    if (!result.Succeeded)
                    {
                        _logger.LogError("Failed to seed the role {0}: {1}", role, string.Join(", ", result.Errors));
                    }
                }
                #endregion

                #region Add default users
                // Add default admins
                var admins = new (string userName, string pwd)[]
                {
                    ("admin1@gmail.com", "123456"),
                    ("admin2@gmail.com", "123456")
                };

                foreach(var admin in admins)
                {
                    var (result , adminId) = await _identityService.CreateUserAsync(admin.userName, admin.pwd);

                    if (!result.Succeeded)
                    {
                        _logger.LogError("Failed to seed the admin {0}: {1}", admin.userName, string.Join(", ", result.Errors));
                        continue;
                    }
                 
                    await _identityService.AddToRoleAsync(adminId, Roles.Administrator);
                }

                // Add default users
                var users = new (string userName, string pwd)[]
                {
                    ("user1@gmail.com", "123456"),
                    ("user2@gmail.com", "123456")
                };

                foreach (var user in users)
                {
                    var (result, userId) = await _identityService.CreateUserAsync(user.userName, user.pwd);

                    if (!result.Succeeded)
                    {
                        _logger.LogError("Failed to seed the user {0}: {1}", user.userName, string.Join(", ", result.Errors));
                        continue;
                    }

                    await _identityService.AddToRoleAsync(userId, Roles.User);
                }
                #endregion
            }

            #region Seed System Settings
            if (!_context.SystemSettings.Any())
            {
                var systemSettings = new List<SystemSetting>
                {
                    new SystemSetting
                    {
                        SettingKey = "Currency",
                        SettingValue = Currency.USD.ToString(),
                        DataType = DataType.String,
                        Description = "Default currency used in transactions",
                        Type = SettingType.General,
                        UserConfigurable = true
                    },
                    new SystemSetting
                    {
                        SettingKey = "Language",
                        SettingValue = Language.EN.ToString(),
                        DataType = DataType.String,
                        Description = "Default application language",
                        Type = SettingType.General,
                        UserConfigurable = true
                    },
                    new SystemSetting
                    {
                        SettingKey = "RequiresConfirmation",
                        SettingValue = "true",
                        DataType = DataType.Boolean,
                        Description = "Indicates whether user actions require confirmation",
                        Type = SettingType.General,
                        UserConfigurable = true
                    }
                };

                _context.SystemSettings.AddRange(systemSettings);
                await _context.SaveChangesAsync();

                _logger.LogInformation("Seeded default system settings.");
            }
            #endregion
        }
    }
}
