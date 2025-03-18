using EMS.Core.Entities;
using EMS.Infrastructure.Persistence.Configurations.Common;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;

namespace EMS.Infrastructure.Persistence.Configurations
{
    public class ChatExtractionConfiguration : EntityTypeConfiguration<ChatExtraction>
    {
        public override void ConfigureProperties(EntityTypeBuilder<ChatExtraction> builder)
        {
            builder.Property(e => e.ExtractionType)
                .HasConversion<string>()
                .HasMaxLength(15);

            builder.Property(e => e.ExtractedData)
                .HasColumnType("jsonb");
        }

        public override void ConfigureRelationships(EntityTypeBuilder<ChatExtraction> builder)
        {
            builder.HasMany(e => e.ExtractedTransactions)
                .WithOne(e => e.ChatExtraction)
                .HasForeignKey(e => e.ChatExtractionId)
                .IsRequired();
        }
    }
}
