using EMS.Core.Enums;
using EMS.Core.Specifications.Common;

namespace EMS.Core.Specifications
{
    public class ScheduledEventSpecParams : PaginationSpecParams
    {
        public DateTimeOffset? NextOccurrenceFrom { get; set; }
        public DateTimeOffset? NextOccurrenceTo { get; set; }
        public DateTimeOffset? LastOccurrenceFrom { get; set; }
        public DateTimeOffset? LastOccurrenceTo { get; set; }
        public EventType? Type { get; set; }
        public string? Text { get; set; }
        public string? Name { get; set; }
        public string? Description { get; set; }
        public EventStatus? Status { get; set; }

        public bool? SortByNextOccurrence { get; set; }
    }
}
