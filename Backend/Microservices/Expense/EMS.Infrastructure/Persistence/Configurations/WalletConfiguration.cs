using EMS.Core.Entities;
using EMS.Infrastructure.Persistence.Configurations.Common;
using Microsoft.EntityFrameworkCore.Metadata.Builders;

namespace EMS.Infrastructure.Persistence.Configurations
{
    public class WalletConfiguration : EntityTypeConfiguration<Wallet>
    {
        public override void ConfigureProperties(EntityTypeBuilder<Wallet> builder)
        {
            builder.Property(e => e.UserId)
                .HasMaxLength(36);

            builder.Property(e => e.Name)
                .HasMaxLength(255);
        }

        public override void ConfigureRelationships(EntityTypeBuilder<Wallet> builder)
        {
            builder.HasMany(e => e.CalendarEvents)
                .WithOne(e => e.Wallet)
                .HasForeignKey(e => e.WalletId)
                .IsRequired();

            builder.HasMany(e => e.FinancialGoals)
                .WithOne(e => e.Wallet)
                .HasForeignKey(e => e.WalletId)
                .IsRequired();

            builder.HasMany(e => e.Transactions)
                .WithOne(e => e.Wallet)
                .HasForeignKey(e => e.WalletId)
                .IsRequired();

        }
    }
}
