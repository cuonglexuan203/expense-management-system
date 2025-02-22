using EMS.Core.Entities;
using EMS.Infrastructure.Identity.Models;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;

namespace EMS.Infrastructure.Persistence.Configurations
{
    public class ApplicationUserConfiguration : IEntityTypeConfiguration<ApplicationUser>
    {
        public void Configure(EntityTypeBuilder<ApplicationUser> builder)
        {
            ConfigureProperties(builder);
            ConfigureRelationships(builder);
        }

        private void ConfigureProperties(EntityTypeBuilder<ApplicationUser> builder)
        {
            builder.Property(e => e.FullName)
                .HasMaxLength(255);

            builder.Property(e => e.Avatar)
                .HasMaxLength(500);
        }

        private void ConfigureRelationships(EntityTypeBuilder<ApplicationUser> builder)
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
        }
    }
}
