using EMS.Core.Entities;
using EMS.Infrastructure.Persistence.Configurations.Common;
using Microsoft.EntityFrameworkCore.Metadata.Builders;

namespace EMS.Infrastructure.Persistence.Configurations
{
    public class MediaConfiguration : EntityTypeConfiguration<Media>
    {
        public override void ConfigureProperties(EntityTypeBuilder<Media> builder)
        {
            builder.Property(e => e.FileName)
                .HasMaxLength(255);

            builder.Property(e => e.ContentType)
                .HasMaxLength(31);

            builder.Property(e => e.Url)
                .HasMaxLength(1023);

            builder.Property(e => e.Extension)
                .HasMaxLength(15);

            builder.Property(e => e.Type)
                .HasConversion<string>()
                .HasMaxLength(15);

            builder.Property(e => e.AltText)
                .HasMaxLength(255);

            builder.Property(e => e.Caption)
                .HasMaxLength(255);

            builder.Property(e => e.Status)
                .HasConversion<string>()
                .HasMaxLength(15);
        }
    }
}
