using EMS.Core.Entities;
using EMS.Infrastructure.Persistence.Configurations.Common;
using Microsoft.EntityFrameworkCore.Metadata.Builders;

namespace EMS.Infrastructure.Persistence.Configurations
{
    public class SystemSettingConfiguration : EntityTypeConfiguration<SystemSetting>
    {
        public override void ConfigureProperties(EntityTypeBuilder<SystemSetting> builder)
        {
            builder.Property(e => e.SettingKey)
                .HasMaxLength(255);

            builder.Property(e => e.SettingValue)
                .HasMaxLength(255);

            builder.Property(e => e.DataType)
                .HasConversion<string>()
                .HasMaxLength(15);

            builder.Property(e => e.Type)
                .HasConversion<string>()
                .HasMaxLength(31);
        }
    }
}
