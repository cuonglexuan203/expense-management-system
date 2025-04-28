using EMS.Core.Entities;
using EMS.Infrastructure.Persistence.Configurations.Common;
using Microsoft.EntityFrameworkCore.Metadata.Builders;

namespace EMS.Infrastructure.Persistence.Configurations
{
    public class RecurrenceRuleConfiguration : EntityTypeConfiguration<RecurrenceRule>
    {
        public override void ConfigureProperties(EntityTypeBuilder<RecurrenceRule> builder)
        {
            builder.Property(e => e.Frequency)
                .HasConversion<string>()
                .HasMaxLength(15);
        }
    }
}
