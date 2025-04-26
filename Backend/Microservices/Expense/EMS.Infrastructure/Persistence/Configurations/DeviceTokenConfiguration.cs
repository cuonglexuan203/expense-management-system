using EMS.Core.Entities;
using EMS.Infrastructure.Identity.Models;
using EMS.Infrastructure.Persistence.Configurations.Common;
using Microsoft.EntityFrameworkCore.Metadata.Builders;

namespace EMS.Infrastructure.Persistence.Configurations
{
    public class DeviceTokenConfiguration : EntityTypeConfiguration<DeviceToken>
    {
        public override void ConfigureProperties(EntityTypeBuilder<DeviceToken> builder)
        {
            builder.Property(e => e.UserId)
                .HasMaxLength(36);

            builder.Property(e => e.Token)
                .HasMaxLength(1024);

            builder.Property(e => e.Platform)
                .HasConversion<string>()
                .HasMaxLength(15);
        }

        public override void ConfigureRelationships(EntityTypeBuilder<DeviceToken> builder)
        {
            builder.HasOne<ApplicationUser>()
                .WithMany(e => e.DeviceTokens)
                .HasForeignKey(e => e.UserId)
                .IsRequired();
        }
    }
}
