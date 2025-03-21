using EMS.Core.Entities;
using EMS.Infrastructure.Persistence.Configurations.Common;
using Microsoft.EntityFrameworkCore.Metadata.Builders;

namespace EMS.Infrastructure.Persistence.Configurations
{
    public class TransactionConfiguration : EntityTypeConfiguration<Transaction>
    {
        public override void ConfigureProperties(EntityTypeBuilder<Transaction> builder)
        {
            builder.Property(e => e.Name)
                .HasMaxLength(255);

            builder.Property(e => e.UserId)
                .HasMaxLength(36);

            builder.Property(e => e.Type)
                .HasConversion<string>()
                .HasMaxLength(15);

            builder.Property(e => e.CurrencyCode)
                .HasConversion<string>()
                .HasMaxLength(3);
        }

        public override void ConfigureRelationships(EntityTypeBuilder<Transaction> builder)
        {
            builder.HasOne(e => e.Currency)
                .WithMany()
                .HasForeignKey(e => e.CurrencyCode)
                .IsRequired();

            builder.HasOne(e => e.ExtractedTransaction)
                .WithOne(e => e.Transaction)
                .HasForeignKey<ExtractedTransaction>(e => e.TransactionId)
                .IsRequired(false);
        }
    }
}
