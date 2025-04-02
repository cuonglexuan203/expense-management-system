using EMS.Core.Entities;
using EMS.Infrastructure.Persistence.Configurations.Common;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;

namespace EMS.Infrastructure.Persistence.Configurations
{
    public class CurrencySlangConfiguration : EntityTypeConfiguration<CurrencySlang>
    {
        public override void ConfigureProperties(EntityTypeBuilder<CurrencySlang> builder)
        {
            builder.Property(e => e.CurrencyCode)
                .HasConversion<string>()
                .HasMaxLength(3);

            builder.Property(e => e.SlangTerm)
                .HasMaxLength(255);

            builder.Property(e => e.Multiplier)
                .HasColumnType("decimal(20, 4)");
        }

        public override void ConfigureRelationships(EntityTypeBuilder<CurrencySlang> builder)
        {
            builder.HasOne(e => e.Currency)
                .WithMany()
                .HasForeignKey(e => e.CurrencyCode)
                .IsRequired();
        }
    }
}
