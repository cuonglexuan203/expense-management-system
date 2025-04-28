using EMS.Core.Entities;
using EMS.Core.ValueObjects;
using Microsoft.EntityFrameworkCore;

namespace EMS.Application.Common.Interfaces.DbContext
{
    public interface IApplicationDbContext
    {
        DbSet<ActivityLog> ActivityLogs { get; set; }
        DbSet<Category> Categories { get; set; }
        DbSet<ChatMessage> ChatMessages { get; set; }
        DbSet<ChatThread> ChatThreads { get; set; }
        DbSet<FinancialGoal> FinancialGoals { get; set; }
        DbSet<Media> Media { get; set; }
        DbSet<NotificationPreference> NotificationPreferences { get; set; }
        DbSet<SystemSetting> SystemSettings { get; set; }
        DbSet<Transaction> Transactions { get; set; }
        DbSet<UserPreference> UserPreferences { get; set; }
        DbSet<Wallet> Wallets { get; set; }
        DbSet<RefreshToken> RefreshTokens { get; set; }
        DbSet<ChatExtraction> ChatExtractions { get; set; }
        DbSet<ExtractedTransaction> ExtractedTransactions { get; set; }
        DbSet<Currency> Currencies { get; set; }
        DbSet<CurrencySlang> CurrencySlangs { get; set; }
        DbSet<ApiKey> ApiKeys { get; set; }
        DbSet<ApiKeyScope> ApiKeyScopes { get; set; }
        DbSet<DeviceToken> DeviceTokens { get; set; }
        DbSet<Notification> Notifications { get; set; }
        DbSet<ScheduledEvent> ScheduledEvents { get; set; }
        DbSet<RecurrenceRule> RecurrenceRules { get; set; }
        DbSet<ScheduledEventExecution> ScheduledEventExecutions { get; set; }

        Task<int> SaveChangesAsync(CancellationToken cancellationToken = default);
    }
}
