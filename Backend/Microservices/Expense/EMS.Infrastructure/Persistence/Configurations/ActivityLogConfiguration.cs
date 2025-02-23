using EMS.Core.Entities;
using EMS.Infrastructure.Persistence.Configurations.Common;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;

namespace EMS.Infrastructure.Persistence.Configurations
{
    public class ActivityLogConfiguration : EntityTypeConfiguration<ActivityLog>
    {
        public override void ConfigureProperties(EntityTypeBuilder<ActivityLog> builder)
        {
            builder.Property(e => e.UserId)
                .HasMaxLength(36);

            builder.Property(e => e.Type)
                .HasConversion<string>()
                .HasMaxLength(15);

            builder.Property(e => e.EntityType)
                .HasMaxLength(255);

            builder.Property(e => e.OldValues)
                .HasColumnType("jsonb");

            builder.Property(e => e.NewValues)
                .HasColumnType("jsonb");

            builder.Property(e => e.PrimaryKey)
                .HasColumnType("jsonb");

            builder.Property(e => e.AffectedColumns)
                .HasColumnType("jsonb");

            builder.Property(e => e.IpAddress)
                .HasMaxLength(500);

            builder.Property(e => e.UserAgent)
                .HasMaxLength(255);
        }
    }
}
