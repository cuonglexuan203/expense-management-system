using EMS.Application.Common.Interfaces.DbContext;
using EMS.Core.Entities;
using EMS.Core.ValueObjects;
using EMS.Infrastructure.Common.Extensions;
using EMS.Infrastructure.Identity.Models;
using Microsoft.AspNetCore.Identity.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore;
using System.Reflection;

namespace EMS.Infrastructure.Persistence.DbContext
{
    public class ApplicationDbContext : IdentityDbContext<ApplicationUser, ApplicationRole, string>, IApplicationDbContext
    {
        public ApplicationDbContext(DbContextOptions<ApplicationDbContext> options) : base(options)
        {

        }

        public DbSet<ActivityLog> ActivityLogs { get; set; }
        public DbSet<CalendarEvent> CalendarEvents { get; set; }
        public DbSet<Category> Categories { get; set; }
        public DbSet<ChatMessage> ChatMessages { get; set; }
        public DbSet<ChatThread> ChatThreads { get; set; }
        public DbSet<FinancialGoal> FinancialGoals { get; set; }
        public DbSet<Media> Media { get; set; }
        public DbSet<NotificationPreference> NotificationPreferences { get; set; }
        public DbSet<SystemSetting> SystemSettings { get; set; }
        public DbSet<Transaction> Transactions { get; set; }
        public DbSet<UserPreference> UserPreferences { get; set; }
        public DbSet<Wallet> Wallets { get; set; }
        public DbSet<RefreshToken> RefreshTokens { get; set; }
        public DbSet<ChatExtraction> ChatExtractions { get; set; }
        public DbSet<ExtractedTransaction> ExtractedTransactions { get; set; }
        public DbSet<Currency> Currencies { get; set; }

        protected override void OnConfiguring(DbContextOptionsBuilder optionsBuilder)
        {
            base.OnConfiguring(optionsBuilder);
        }

        protected override void OnModelCreating(ModelBuilder builder)
        {
            base.OnModelCreating(builder);

            builder.AddPostgreExtensions()
                .MapPostgreDbFunctions()
                .ApplyConfigurationsFromAssembly(Assembly.GetExecutingAssembly());
        }
    }
}
