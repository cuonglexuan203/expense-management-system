﻿using EMS.Core.Common.Interfaces.Audit;
using EMS.Core.Entities;
using Microsoft.AspNetCore.Identity;

namespace EMS.Infrastructure.Identity.Models
{
    public class ApplicationUser : IdentityUser, IUser<string>, IAuditableEntity
    {
        public string FullName { get; set; } = default!;
        public string? Avatar { get; set; }
        public DateTimeOffset? CreatedAt { get; set; }
        public string? CreatedBy { get; set; }
        public DateTimeOffset? ModifiedAt { get; set; }
        public string? ModifiedBy { get; set; }
        public bool IsDeleted { get; set; }
        public DateTimeOffset? DeletedAt { get; set; }
        public string? DeletedBy { get; set; }

        // Navigations
        public UserPreference UserPreference { get; set; } = default!;
        public ICollection<NotificationPreference> NotificationPreferences { get; set; } = [];
        public ICollection<ChatThread> ChatThreads { get; set; } = [];
        public ICollection<ActivityLog> ActivityLogs { get; set; } = [];
        public ICollection<FinancialGoal> FinancialGoals { get; set; } = [];
        public ICollection<Category> Categories { get; set; } = [];
        public ICollection<Transaction> Transactions { get; set; } = [];
        public ICollection<Wallet> Wallets { get; set; } = [];
        public ICollection<RefreshToken> RefreshTokens { get; set; } = [];
        public ICollection<DeviceToken> DeviceTokens { get; set; } = [];
        public ICollection<ExtractedTransaction> ExtractedTransactions { get; set; } = [];
        public ICollection<Notification> Notifications { get; set; } = [];
        public ICollection<ScheduledEvent> ScheduledEvents { get; set; } = [];
    }
}
