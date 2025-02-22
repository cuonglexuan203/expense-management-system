using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Logging;

namespace EMS.Infrastructure.Persistence.DbContext
{
    public class ApplicationDbContextInitializer
    {
        private readonly ILogger<ApplicationDbContextInitializer> _logger;
        private readonly ApplicationDbContext _context;

        public ApplicationDbContextInitializer(ILogger<ApplicationDbContextInitializer> logger, ApplicationDbContext context)
        {
            _logger = logger;
            _context = context;
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
            catch (Exception ex)
            {
                _logger.LogError("An error occurred while seeding the database.");
                throw;
            }
        }

        public async Task TrySeedAsync()
        {

        }
    }
}
