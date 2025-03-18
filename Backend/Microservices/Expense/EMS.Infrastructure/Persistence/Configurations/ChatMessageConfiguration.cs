using EMS.Core.Entities;
using EMS.Infrastructure.Persistence.Configurations.Common;
using Microsoft.EntityFrameworkCore.Metadata.Builders;

namespace EMS.Infrastructure.Persistence.Configurations
{
    public class ChatMessageConfiguration : EntityTypeConfiguration<ChatMessage>
    {
        public override void ConfigureProperties(EntityTypeBuilder<ChatMessage> builder)
        {
            builder.Property(e => e.UserId)
                .HasMaxLength(36);

            builder.Property(e => e.Role)
                .HasConversion<string>()
                .HasMaxLength(15);
        }

        public override void ConfigureRelationships(EntityTypeBuilder<ChatMessage> builder)
        {
            builder.HasMany(e => e.Medias)
                .WithOne(e => e.ChatMessage)
                .HasForeignKey(e => e.ChatMessageId)
                .IsRequired(false);

            builder.HasOne(e => e.Transaction)
                .WithOne(e => e.ChatMessage)
                .HasForeignKey<Transaction>(e => e.ChatMessageId)
                .IsRequired(false);

            builder.HasOne(e => e.ChatExtraction)
                .WithOne(e => e.ChatMessage)
                .HasForeignKey<ChatExtraction>(e => e.ChatMessageId)
                .IsRequired();

            builder.HasMany(e => e.ExtractedTransactions)
                .WithOne(e => e.ChatMessage)
                .HasForeignKey(e => e.ChatMessageId);
        }
    }
}
