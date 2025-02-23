using EMS.Core.Common.Interfaces.Audit;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;

namespace EMS.Infrastructure.Persistence.Configurations.Common
{
    public abstract class EntityTypeConfiguration<TEntity> : IEntityTypeConfiguration<TEntity> where TEntity : class
    {
        void IEntityTypeConfiguration<TEntity>.Configure(EntityTypeBuilder<TEntity> builder)
        {
            ConfigureAuditProperties(builder);
            Configure(builder);
            ConfigureProperties(builder);
            ConfigureRelationships(builder);
        }

        private void ConfigureAuditProperties(EntityTypeBuilder<TEntity> builder)
        {
            if(typeof(IDeleted).IsAssignableFrom(typeof(TEntity)))
            {
                builder.Property(nameof(IDeleted.DeletedBy))
                    .HasMaxLength(36);
            }

            if (typeof(ICreated).IsAssignableFrom(typeof(TEntity)))
            {
                builder.Property(nameof(ICreated.CreatedBy))
                    .HasMaxLength(36);
            }

            if (typeof(IModified).IsAssignableFrom(typeof(TEntity)))
            {
                builder.Property(nameof(IModified.ModifiedBy))
                    .HasMaxLength(36);
            }
        }

        public virtual void Configure(EntityTypeBuilder<TEntity> builder)
        {

        }

        public virtual void ConfigureProperties(EntityTypeBuilder<TEntity> builder)
        {

        }

        public virtual void ConfigureRelationships(EntityTypeBuilder<TEntity> builder)
        {

        }
    }
}
