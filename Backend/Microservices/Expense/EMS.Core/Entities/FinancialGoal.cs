using EMS.Core.Entities.Common;
using EMS.Core.Enums;

namespace EMS.Core.Entities
{
    public class FinancialGoal : BaseAuditableEntity<int>
    {
        public string UserId { get; set; } = default!;
        public int WalletId { get; set; }
        public string Title { get; set; } = default!;
        public float TargetAmount { get; set; }
        public float CurrentAmount { get; set; }
        public DateTimeOffset StartTime { get; set; }
        public DateTimeOffset EndTime { get; set; }
        public FinancialGoalStatus Status { get; set; }

        // Navigations
        public Wallet Wallet { get; set; } = default!;
    }
}
