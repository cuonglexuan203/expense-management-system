using EMS.Core.Entities;
using EMS.Infrastructure.Persistence.Configurations.Common;
using Microsoft.EntityFrameworkCore.Metadata.Builders;

namespace EMS.Infrastructure.Persistence.Configurations
{
    public class ApiKeyScopeConfiguration : EntityTypeConfiguration<ApiKeyScope>
    {
        public override void ConfigureProperties(EntityTypeBuilder<ApiKeyScope> builder)
        {
            builder.Property(e => e.Scope)
                .HasMaxLength(100)
                .IsRequired();
        }
    }
}
