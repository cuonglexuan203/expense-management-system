using EMS.Application.Common.Mappings;
using EMS.Core.Entities;
using EMS.Core.Enums;

namespace EMS.Application.Features.Events.Dtos
{
    public class RecurrenceRuleDto : IMapFrom<RecurrenceRule>
    {
        //public int Id { get; set; }
        public RecurrenceType Frequency { get; set; }
        public int Interval { get; set; }
        public string[] ByDayOfWeek { get; set; } = [];
        public int[] ByMonthDay { get; set; } = [];
        public int[] ByMonth { get; set; } = [];
        public DateTimeOffset? EndDate { get; set; }
        public int? MaxOccurrences { get; set; }

        //public DateTimeOffset? CreatedAt { get; set; }
    }
}
