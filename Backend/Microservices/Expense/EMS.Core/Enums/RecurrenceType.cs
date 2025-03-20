using System.ComponentModel;

namespace EMS.Core.Enums
{
    public enum RecurrenceType
    {
        [Description("No Recurrence")]
        Once,

        [Description("Daily")]
        Daily,

        [Description("Weekly")]
        Weekly,

        [Description("Monthly")]
        Monthly,

        [Description("Yearly")]
        Yearly
    }
}
