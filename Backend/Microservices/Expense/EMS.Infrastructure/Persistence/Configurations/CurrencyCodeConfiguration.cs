using EMS.Core.ValueObjects;
using EMS.Infrastructure.Persistence.Configurations.Common;
using Microsoft.EntityFrameworkCore.Metadata.Builders;

namespace EMS.Infrastructure.Persistence.Configurations
{
    public class CurrencyCodeConfiguration : EntityTypeConfiguration<Currency>
    {
        public override void ConfigureProperties(EntityTypeBuilder<Currency> builder)
        {
            builder.HasKey(e => e.Code);

            builder.Property(e => e.Code)
                .HasConversion<string>()
                .HasMaxLength(3)
                .IsRequired()
                .IsUnicode(false);

            builder.Property(e => e.Country)
                .HasMaxLength(100)
                .IsRequired();

            builder.Property(e => e.CurrencyName)
                .HasMaxLength(100)
                .IsRequired();
        }
    }
}
