using System.ComponentModel;

namespace EMS.Core.Enums
{
    public enum NotificationType
    {
        [Description("Notification for normal event")]
        EventReminder,

        //[Description("Notification for periodic event")]
        //PeriodicEventReminder,

        [Description("Budget Limit Alerts")]
        BudgetAlert,

        [Description("Monthly Financial Reports")]
        MonthlyReport,

        [Description("AI Spending Insights")]
        AiInsight,

        [Description("Notification Analysis")]
        NotificationAnalysis,
    }
}
