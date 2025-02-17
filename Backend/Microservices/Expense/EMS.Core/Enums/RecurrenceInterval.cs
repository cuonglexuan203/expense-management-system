using System.ComponentModel;

namespace EMS.Core.Enums
{
    public enum RecurrenceInterval
    {
        [Description("No Recurrence")]
        None,

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
