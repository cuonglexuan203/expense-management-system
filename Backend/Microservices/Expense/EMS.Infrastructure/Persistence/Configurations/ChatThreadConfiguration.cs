using EMS.Core.Entities;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;

namespace EMS.Infrastructure.Persistence.Configurations
{
    public class ChatThreadConfiguration : IEntityTypeConfiguration<ChatThread>
    {

        public void Configure(EntityTypeBuilder<ChatThread> builder)
        {
            ConfigureProperties(builder);
            ConfigureRelationships(builder);
        }

        private void ConfigureProperties(EntityTypeBuilder<ChatThread> builder)
        {
            
        }

        private void ConfigureRelationships(EntityTypeBuilder<ChatThread> builder)
        {
            builder.HasMany(e => e.ChatMessages)
                .WithOne(e => e.ChatThread)
                .HasForeignKey(e => e.ChatThreadId);
        }
    }
}
