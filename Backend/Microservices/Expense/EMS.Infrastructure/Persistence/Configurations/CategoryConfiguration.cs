using EMS.Core.Entities;
using EMS.Infrastructure.Persistence.Configurations.Common;
using Microsoft.EntityFrameworkCore.Metadata.Builders;

namespace EMS.Infrastructure.Persistence.Configurations
{
    public class CategoryConfiguration : EntityTypeConfiguration<Category>
    {
        public override void ConfigureProperties(EntityTypeBuilder<Category> builder)
        {
            builder.Property(e => e.UserId)
                .HasMaxLength(36);

            builder.Property(e => e.Name)
                .HasMaxLength(255);

            builder.Property(e => e.Type)
                .HasConversion<string>()
                .HasMaxLength(15);
        }
        public override void ConfigureRelationships(EntityTypeBuilder<Category> builder)
        {
            builder.HasMany(e => e.Transactions)
                .WithOne(e => e.Category)
                .HasForeignKey(e => e.CategoryId)
                .IsRequired(false);
        }
    }
}
