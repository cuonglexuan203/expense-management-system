using EMS.Core.Enums;

namespace EMS.Application.Features.Wallets.Queries.GetWalletSummary
{
    public class WalletBalanceSummary
    {
        public int WalletId { get; set; }
        public string Name { get; set; } = default!;
        public float Balance { get; set; }
        public string? Description { get; set; }
        public WalletSummaryPeriod FilterPeriod { get; set; }
        public TransactionSummary? Income { get; set; }
        public TransactionSummary? Expense { get; set; }
        public float BalanceByPeriod => (Income?.TotalAmount ?? 0f) - (Expense?.TotalAmount ?? 0f);
    }
}
