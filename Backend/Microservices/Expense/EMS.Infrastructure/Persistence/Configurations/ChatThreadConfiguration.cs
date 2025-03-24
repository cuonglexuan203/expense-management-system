using EMS.Core.Entities;
using EMS.Infrastructure.Persistence.Configurations.Common;
using Microsoft.EntityFrameworkCore.Metadata.Builders;

namespace EMS.Infrastructure.Persistence.Configurations
{
    public class ChatThreadConfiguration : EntityTypeConfiguration<ChatThread>
    {
        public override void ConfigureProperties(EntityTypeBuilder<ChatThread> builder)
        {
            builder.Property(e => e.UserId)
                .HasMaxLength(36);

            builder.Property(e => e.Title)
                .HasMaxLength(255);

            builder.Property(e => e.Type)
                .HasConversion<string>()
                .HasMaxLength(15);
        }

        public override void ConfigureRelationships(EntityTypeBuilder<ChatThread> builder)
        {
            builder.HasMany(e => e.ChatMessages)
                .WithOne(e => e.ChatThread)
                .HasForeignKey(e => e.ChatThreadId);
        }
    }
}
