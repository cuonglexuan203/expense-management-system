using EMS.Core.Entities;
using EMS.Infrastructure.Persistence.Configurations.Common;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;

namespace EMS.Infrastructure.Persistence.Configurations
{
    public class ScheduledEventConfiguration : EntityTypeConfiguration<ScheduledEvent>
    {
        public override void ConfigureProperties(EntityTypeBuilder<ScheduledEvent> builder)
        {
            builder.Property(e => e.UserId)
                .HasMaxLength(36);

            builder.Property(e => e.Name)
                .HasMaxLength(255);

            builder.Property(e => e.Description)
                .HasColumnType("text");

            builder.Property(e => e.Type)
                .HasConversion<string>()
                .HasMaxLength(50);

            builder.Property(e => e.Payload)
                .HasColumnType("jsonb");

            builder.Property(e => e.Status)
                .HasConversion<string>()
                .HasMaxLength(50);
        }

        public override void ConfigureRelationships(EntityTypeBuilder<ScheduledEvent> builder)
        {
            builder.HasOne(e => e.RecurrenceRule)
                .WithOne()
                .HasForeignKey<ScheduledEvent>(e => e.RecurrenceRuleId)
                .IsRequired(false);

            //builder.HasOne(e => e.User)
            //    .WithMany()
            //    .HasForeignKey(e => e.UserId)
            //    .IsRequired();
        }
    }
}
