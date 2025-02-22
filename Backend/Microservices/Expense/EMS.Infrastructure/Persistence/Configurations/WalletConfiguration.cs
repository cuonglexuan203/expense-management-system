using EMS.Core.Entities;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;

namespace EMS.Infrastructure.Persistence.Configurations
{
    public class WalletConfiguration : IEntityTypeConfiguration<Wallet>
    {
        public void Configure(EntityTypeBuilder<Wallet> builder)
        {
            ConfigureProperties(builder);
            ConfigureRelationships(builder);
        }

        private void ConfigureProperties(EntityTypeBuilder<Wallet> builder)
        {

        }

        private void ConfigureRelationships(EntityTypeBuilder<Wallet> builder)
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
