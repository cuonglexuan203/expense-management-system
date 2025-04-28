using EMS.Core.Entities.Common;
using EMS.Core.Enums;

namespace EMS.Core.Entities
{
    public class RecurrenceRule : BaseAuditableEntity<int>
    {
        public RecurrenceType Frequency { get; set; }
        private int _interval = 1;
        public int Interval { get => _interval; set => _interval = value > 0 ? value : 1; }
        public string[] ByDayOfWeek { get; set; } = [];
        public int[] ByMonthDay { get; set; } = [];
        public int[] ByMonth { get; set; } = [];
        public DateTimeOffset? EndDate { get; set; }
        private int? _maxOccurrences = default;
        public int? MaxOccurrences { get => _maxOccurrences; set => _maxOccurrences = value == null 
                ? null 
                : value > 0 
                    ? value 
                    : _maxOccurrences; }

        // Navigations
    }
}
