using System.ComponentModel;

namespace EMS.Core.Enums
{
    public enum FinancialGoalStatus
    {
        [Description("Not Started")]
        NotStarted,

        [Description("In Progress")]
        InProgress,

        [Description("Archived")]
        Archived,

        [Description("Failed")]
        Failed,

        [Description("Cancelled")]
        Cancelled
    }
}
