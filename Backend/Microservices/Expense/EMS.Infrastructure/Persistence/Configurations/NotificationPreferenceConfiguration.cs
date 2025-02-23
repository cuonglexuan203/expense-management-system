using EMS.Core.Entities;
using EMS.Infrastructure.Persistence.Configurations.Common;
using Microsoft.EntityFrameworkCore.Metadata.Builders;

namespace EMS.Infrastructure.Persistence.Configurations
{
    public class NotificationPreferenceConfiguration : EntityTypeConfiguration<NotificationPreference>
    {
        public override void ConfigureProperties(EntityTypeBuilder<NotificationPreference> builder)
        {
            builder.Property(e => e.UserId)
                .HasMaxLength(36);

            builder.Property(e => e.Type)
                .HasConversion<string>()
                .HasMaxLength(31);

            builder.Property(e => e.Channel)
                .HasConversion<string>()
                .HasMaxLength(15);
        }
    }
}
