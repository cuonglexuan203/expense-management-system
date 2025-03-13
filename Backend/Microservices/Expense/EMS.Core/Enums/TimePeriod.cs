using System.ComponentModel;

namespace EMS.Core.Enums
{
    public enum TimePeriod
    {
        [Description("All Time")]
        AllTime,

        [Description("Current Week")]
        CurrentWeek,

        [Description("Current Month")]
        CurrentMonth,

        [Description("Current Year")]
        CurrentYear,
    }
}
