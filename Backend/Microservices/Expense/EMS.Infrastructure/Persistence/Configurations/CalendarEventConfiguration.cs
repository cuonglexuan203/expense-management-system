using EMS.Core.Entities;
using EMS.Infrastructure.Persistence.Configurations.Common;
using Microsoft.EntityFrameworkCore.Metadata.Builders;

namespace EMS.Infrastructure.Persistence.Configurations
{
    public class CalendarEventConfiguration : EntityTypeConfiguration<CalendarEvent>
    {
        public override void ConfigureProperties(EntityTypeBuilder<CalendarEvent> builder)
        {
            builder.Property(e => e.UserId)
                .HasMaxLength(36);

            builder.Property(e => e.Title)
                .HasMaxLength(255);

            builder.Property(e => e.Interval)
                .HasConversion<string>()
                .HasMaxLength(15);

            builder.Property(e => e.Location)
                .HasMaxLength(500);

            builder.Property(e => e.TransactionType)
                .HasConversion<string>()
                .HasMaxLength(15);
        }

        public override void ConfigureRelationships(EntityTypeBuilder<CalendarEvent> builder)
        {
            builder.HasMany(e => e.Transactions)
                .WithOne(e => e.CalendarEvent)
                .HasForeignKey(e => e.CalendarEventId)
                .IsRequired(false);
        }
    }
}
