using EMS.Core.Entities;
using EMS.Infrastructure.Persistence.Configurations.Common;
using Microsoft.EntityFrameworkCore.Metadata.Builders;

namespace EMS.Infrastructure.Persistence.Configurations
{
    public class FinancialGoalConfiguration : EntityTypeConfiguration<FinancialGoal>
    {
        public override void ConfigureProperties(EntityTypeBuilder<FinancialGoal> builder)
        {
            builder.Property(e => e.UserId)
                .HasMaxLength(36);

            builder.Property(e => e.Title)
                .HasMaxLength(255);

            builder.Property(e => e.Status)
                .HasConversion<string>()
                .HasMaxLength(15);
        }
    }
}
