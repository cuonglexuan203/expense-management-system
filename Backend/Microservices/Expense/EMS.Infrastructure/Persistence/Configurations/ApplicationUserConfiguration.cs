using EMS.Core.Entities;
using EMS.Infrastructure.Identity.Models;
using EMS.Infrastructure.Persistence.Configurations.Common;
using Microsoft.EntityFrameworkCore.Metadata.Builders;

namespace EMS.Infrastructure.Persistence.Configurations
{
    public class ApplicationUserConfiguration : EntityTypeConfiguration<ApplicationUser>
    {
        public override void Configure(EntityTypeBuilder<ApplicationUser> builder)
        {

        }

        public override void ConfigureProperties(EntityTypeBuilder<ApplicationUser> builder)
        {
            builder.Property(e => e.FullName)
                .HasMaxLength(255);

            builder.Property(e => e.Avatar)
                .HasMaxLength(500);
        }

        public override void ConfigureRelationships(EntityTypeBuilder<ApplicationUser> builder)
        {
            builder.HasOne(e => e.UserPreference)
                .WithOne()
                .HasForeignKey<UserPreference>(e => e.UserId)
                .IsRequired();

            builder.HasMany(e => e.NotificationPreferences)
                .WithOne()
                .HasForeignKey(e => e.UserId)
                .IsRequired();

            builder.HasMany(e => e.ChatThreads)
                .WithOne()
                .HasForeignKey(e => e.UserId)
                .IsRequired();

            builder.HasMany(e => e.ActivityLogs)
                .WithOne()
                .HasForeignKey(e => e.UserId)
                .IsRequired();

            builder.HasMany(e => e.CalendarEvents)
                .WithOne()
                .HasForeignKey(e => e.UserId)
                .IsRequired();

            builder.HasMany(e => e.FinancialGoals)
                .WithOne()
                .HasForeignKey(e => e.UserId)
                .IsRequired();

            builder.HasMany(e => e.Categories)
                .WithOne()
                .HasForeignKey(e => e.UserId)
                .IsRequired();

            builder.HasMany(e => e.Transactions)
                .WithOne()
                .HasForeignKey(e => e.UserId)
                .IsRequired();

            builder.HasMany(e => e.Wallets)
                .WithOne()
                .HasForeignKey(e => e.UserId)
                .IsRequired();

            builder.HasMany(e => e.RefreshTokens)
                .WithOne(e => e.User as ApplicationUser)
                .IsRequired();
        }
    }
}
