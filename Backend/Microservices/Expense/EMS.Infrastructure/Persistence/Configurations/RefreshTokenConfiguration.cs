using EMS.Core.Entities;
using EMS.Infrastructure.Persistence.Configurations.Common;
using Microsoft.EntityFrameworkCore.Metadata.Builders;

namespace EMS.Infrastructure.Persistence.Configurations
{
    public class RefreshTokenConfiguration : EntityTypeConfiguration<RefreshToken>
    {
        public override void ConfigureProperties(EntityTypeBuilder<RefreshToken> builder)
        {
            builder.Property(e => e.UserId)
                .HasMaxLength(36);

            builder.Property(e => e.Token)
                .HasMaxLength(100);
        }
    }
}
