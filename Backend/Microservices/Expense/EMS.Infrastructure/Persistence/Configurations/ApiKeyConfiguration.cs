using EMS.Core.Entities;
using EMS.Infrastructure.Persistence.Configurations.Common;
using Microsoft.EntityFrameworkCore.Metadata.Builders;

namespace EMS.Infrastructure.Persistence.Configurations
{
    public class ApiKeyConfiguration : EntityTypeConfiguration<ApiKey>
    {
        public override void Configure(EntityTypeBuilder<ApiKey> builder)
        {
            builder.HasIndex(e => e.Key)
                .IsUnique();
        }

        public override void ConfigureProperties(EntityTypeBuilder<ApiKey> builder)
        {
            builder.Property(e => e.Key)
                .HasMaxLength(88);

            builder.Property(e => e.Name)
                .HasMaxLength(100);
            
            builder.Property(e => e.Description)
                .HasMaxLength(500);

            builder.Property(e => e.OwnerId)
                .HasMaxLength(36);
        }

        public override void ConfigureRelationships(EntityTypeBuilder<ApiKey> builder)
        {
            builder.HasMany(e => e.Scopes)
                .WithMany(e => e.ApiKeys);
        }
    }
}
