using EMS.Application.Common.Extensions;
using EMS.Core.Constants;
using EMS.Infrastructure.Persistence.DbContext;
using Microsoft.EntityFrameworkCore;
using Npgsql;
using Polly;
using System;

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
                logger.LogStateInfo(AppStates.RunningMigrations, $"Start Db Migration: {typeof(TContext).Name}");
                // retry strategy
                var retry = Policy.Handle<PostgresException>()
                                    .WaitAndRetry(
                                    retryCount: 5,
                                    sleepDurationProvider: retryAttempt => TimeSpan.FromSeconds(Math.Pow(2, retryAttempt)),
                                    onRetry: (exception, span, context) =>
                                    {
                                        logger.LogStateError(exception, AppStates.RunningMigrations, $"Retrying the migration {span}");
                                    });
                retry.Execute(() => context.Database.Migrate());
                logger.LogStateInfo(AppStates.RunningMigrations, $"Migration completed: {typeof(TContext).Name}");
            }
            catch (Exception ex)
            {
                logger.LogStateError(ex, AppStates.RunningMigrations, $"An error occurred while migrating db: {ex.Message}");
            }
            return host;
        }
    }
}
