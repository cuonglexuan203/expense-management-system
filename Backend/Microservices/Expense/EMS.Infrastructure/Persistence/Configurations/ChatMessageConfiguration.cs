using EMS.Core.Entities;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;

namespace EMS.Infrastructure.Persistence.Configurations
{
    public class ChatMessageConfiguration : IEntityTypeConfiguration<ChatMessage>
    {
        public void Configure(EntityTypeBuilder<ChatMessage> builder)
        {
            ConfigureProperties(builder);
            ConfigureRelationships(builder);
        }

        private void ConfigureProperties(EntityTypeBuilder<ChatMessage> builder)
        {

        }

        private void ConfigureRelationships(EntityTypeBuilder<ChatMessage> builder)
        {
            builder.HasMany(e => e.Medias)
                .WithOne(e => e.ChatMessage)
                .HasForeignKey(e => e.ChatMessageId)
                .IsRequired(false);

            builder.HasOne(e => e.Transaction)
                .WithOne(e => e.ChatMessage)
                .HasForeignKey<Transaction>(e => e.ChatMessageId)
                .IsRequired(false);
        }
    }
}
