using EMS.Core.Entities;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;

namespace EMS.Infrastructure.Persistence.Configurations
{
    public class CalendarEventConfiguration : IEntityTypeConfiguration<CalendarEvent>
    {
        public void Configure(EntityTypeBuilder<CalendarEvent> builder)
        {
            ConfigureProperties(builder);
            ConfigureRelationships(builder);
        }

        private void ConfigureProperties(EntityTypeBuilder<CalendarEvent> builder)
        {
        }

        private void ConfigureRelationships(EntityTypeBuilder<CalendarEvent> builder)
        {
            builder.HasMany(e => e.Transactions)
                .WithOne(e => e.CalendarEvent)
                .HasForeignKey(e => e.CalendarEventId)
                .IsRequired(false);
        }
    }
}
