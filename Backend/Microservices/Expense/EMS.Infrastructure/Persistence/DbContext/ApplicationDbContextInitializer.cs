using EMS.Application.Common.Interfaces.Services;
using EMS.Core.Constants;
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
            }
        }
    }
}
