using EMS.Core.Entities;
using EMS.Infrastructure.Persistence.Configurations.Common;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;

namespace EMS.Infrastructure.Persistence.Configurations
{
    public class NotificationConfiguration : EntityTypeConfiguration<Notification>
    {
        public override void ConfigureProperties(EntityTypeBuilder<Notification> builder)
        {
            builder.Property(e => e.UserId)
                .HasMaxLength(36);

            builder.Property(e => e.Type)
                .HasConversion<string>()
                .HasMaxLength(31);

            builder.Property(e => e.DataPayload)
                .HasColumnType("jsonb");

            builder.Property(e => e.Status)
                .HasConversion<string>()
                .HasMaxLength(15);
        }
    }
}
