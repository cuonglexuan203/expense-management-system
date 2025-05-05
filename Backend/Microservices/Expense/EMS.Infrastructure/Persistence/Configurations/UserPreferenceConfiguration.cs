using EMS.Core.Constants;
using EMS.Core.Entities;
using EMS.Infrastructure.Persistence.Configurations.Common;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;

namespace EMS.Infrastructure.Persistence.Configurations
{
    public class UserPreferenceConfiguration : EntityTypeConfiguration<UserPreference>
    {
        public override void ConfigureProperties(EntityTypeBuilder<UserPreference> builder)
        {
            builder.Property(e => e.UserId)
                .HasMaxLength(36);

            builder.Property(e => e.LanguageCode)
                .HasConversion<string>()
                .HasMaxLength(50);

            builder.Property(e => e.CurrencyCode)
                .HasConversion<string>()
                .HasMaxLength(3);

            builder.Property(e => e.ConfirmationMode)
                .HasConversion<string>()
                .HasMaxLength(15);

            builder.Property(e => e.TimeZoneId)
                .HasMaxLength(100)
                .HasDefaultValue(TimeZoneIds.Asia_Ho_Chi_Minh);
        }

        public override void ConfigureRelationships(EntityTypeBuilder<UserPreference> builder)
        {
            builder.HasOne(e => e.Currency)
                .WithMany()
                .HasForeignKey(e => e.CurrencyCode)
                .IsRequired();
        }
    }
}
