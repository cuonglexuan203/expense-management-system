using EMS.Core.Entities;
using EMS.Infrastructure.Persistence.Configurations.Common;
using Microsoft.EntityFrameworkCore.Metadata.Builders;

namespace EMS.Infrastructure.Persistence.Configurations
{
    public class UserPreferenceConfiguration : EntityTypeConfiguration<UserPreference>
    {
        public override void ConfigureProperties(EntityTypeBuilder<UserPreference> builder)
        {
            builder.Property(e => e.UserId)
                .HasMaxLength(36);

            builder.Property(e => e.Language)
                .HasConversion<string>()
                .HasMaxLength(50);

            builder.Property(e => e.Currency)
                .HasConversion<string>()
                .HasMaxLength(31);

            builder.Property(e => e.ConfirmationMode)
                .HasConversion<string>()
                .HasMaxLength(15);
        }
    }
}
