using EMS.Core.Entities;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;

namespace EMS.Infrastructure.Persistence.Configurations
{
    public class CategoryConfiguration : IEntityTypeConfiguration<Category>
    {
        public void Configure(EntityTypeBuilder<Category> builder)
        {
            ConfigureProperties(builder);
            ConfigureRelationships(builder);
        }
        private void ConfigureProperties(EntityTypeBuilder<Category> builder)
        {

        }
        private void ConfigureRelationships(EntityTypeBuilder<Category> builder)
        {
            builder.HasMany(e => e.Transactions)
                .WithOne(e => e.Category)
                .HasForeignKey(e => e.CategoryId)
                .IsRequired(false);
        }
    }
}
