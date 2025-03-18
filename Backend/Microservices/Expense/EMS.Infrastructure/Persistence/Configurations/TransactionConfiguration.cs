using EMS.Core.Entities;
using EMS.Core.ValueObjects;
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
        }

        public override void ConfigureRelationships(EntityTypeBuilder<Transaction> builder)
        {
            builder.HasOne(e => e.Currency)
                .WithMany()
                .HasForeignKey(nameof(Currency))
                .IsRequired();
        }
    }
}
