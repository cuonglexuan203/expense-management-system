using EMS.Infrastructure.Persistence.DbContext;
using Microsoft.EntityFrameworkCore;
using Npgsql;
using Polly;

namespace EMS.API.Common.Extensions
{
    public static class HostExtensions
    {
        public static async Task InitializeDatabaseAsync(this IHost host)
        {
            var scope = host.Services.CreateScope();
            var initializer = scope.ServiceProvider.GetRequiredService<ApplicationDbContextInitializer>();

            //await initializer.InitializeAsync();

            await initializer.SeedAsync();
        }

        public static IHost MigrateDatabase<TContext>(this IHost host) where TContext : DbContext
        {
            using var scope = host.Services.CreateScope();
            var serviceProvider = scope.ServiceProvider;
            var logger = serviceProvider.GetRequiredService<ILogger<TContext>>();
            var context = serviceProvider.GetRequiredService<TContext>();
            try
            {
                logger.LogInformation("Start Db Migration: {dbName}", typeof(TContext).Name);
                // retry strategy
                var retry = Policy.Handle<PostgresException>()
                                    .WaitAndRetry(
                                    retryCount: 5,
                                    sleepDurationProvider: retryAttempt => TimeSpan.FromSeconds(Math.Pow(2, retryAttempt)),
                                    onRetry: (exception, span, context) =>
                                    {
                                        logger.LogError($"Retrying because of {exception} {span}");
                                    });
                retry.Execute(() => context.Database.Migrate());
                logger.LogInformation("Migration completed: {dbName}", typeof(TContext).Name);
            }
            catch (Exception ex)
            {
                logger.LogError("An error occurred while migrating db: {msg}", ex.Message);
            }
            return host;
        }
    }
}
