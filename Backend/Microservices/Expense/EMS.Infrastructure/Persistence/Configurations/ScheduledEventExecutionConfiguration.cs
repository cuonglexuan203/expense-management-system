using EMS.Core.Entities;
using EMS.Infrastructure.Persistence.Configurations.Common;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;

namespace EMS.Infrastructure.Persistence.Configurations
{
    public class ScheduledEventExecutionConfiguration : EntityTypeConfiguration<ScheduledEventExecution>
    {
        public override void ConfigureProperties(EntityTypeBuilder<ScheduledEventExecution> builder)
        {
            builder.Property(e => e.Status)
                .HasConversion<string>()
                .HasMaxLength(20);

            builder.Property(e => e.Notes)
                .HasColumnType("text");
        }

        public override void ConfigureRelationships(EntityTypeBuilder<ScheduledEventExecution> builder)
        {
            builder.HasOne(e => e.ScheduledEvent)
                .WithMany(e => e.ScheduledEventExecutions)
                .HasForeignKey(e => e.ScheduledEventId)
                .IsRequired();

            builder.HasOne(e => e.Transaction)
                .WithOne()
                .HasForeignKey<ScheduledEventExecution>(e => e.TransactionId)
                .IsRequired(false);
        }
    }
}
