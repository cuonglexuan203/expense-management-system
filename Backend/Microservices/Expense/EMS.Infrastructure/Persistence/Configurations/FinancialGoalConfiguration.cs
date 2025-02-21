using EMS.Core.Entities;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;

namespace EMS.Infrastructure.Persistence.Configurations
{
    public class FinancialGoalConfiguration : IEntityTypeConfiguration<FinancialGoal>
    {
        public void Configure(EntityTypeBuilder<FinancialGoal> builder)
        {
            ConfigureProperties(builder);
            ConfigureRelationships(builder);
        }

        private void ConfigureProperties(EntityTypeBuilder<FinancialGoal> builder)
        {

        }

        private void ConfigureRelationships(EntityTypeBuilder<FinancialGoal> builder)
        {

        }
    }
}
