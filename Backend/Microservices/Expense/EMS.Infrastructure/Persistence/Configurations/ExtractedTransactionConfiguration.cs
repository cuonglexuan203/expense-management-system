using EMS.Core.Entities;
using EMS.Infrastructure.Persistence.Configurations.Common;
using Microsoft.EntityFrameworkCore.Metadata.Builders;

namespace EMS.Infrastructure.Persistence.Configurations
{
    public class ExtractedTransactionConfiguration : EntityTypeConfiguration<ExtractedTransaction>
    {
        public override void ConfigureProperties(EntityTypeBuilder<ExtractedTransaction> builder)
        {
            builder.Property(e => e.Name)
                .HasMaxLength(255);

            builder.Property(e => e.Type)
                .HasConversion<string>()
                .HasMaxLength(15);

            builder.Property(e => e.ConfirmationMode)
                .HasConversion<string>()
                .HasMaxLength(15);

            builder.Property(e => e.ConfirmationStatus)
                .HasConversion<string>()
                .HasMaxLength(15);
        }
        public override void ConfigureRelationships(EntityTypeBuilder<ExtractedTransaction> builder)
        {
            builder.HasOne(e => e.Currency)
                .WithMany()
                //.HasForeignKey(nameof(Currency.Code))
                .IsRequired();
        }
    }
}
