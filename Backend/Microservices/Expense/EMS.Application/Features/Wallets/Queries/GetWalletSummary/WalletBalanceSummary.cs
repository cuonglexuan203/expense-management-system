using EMS.Core.Enums;
using System; // Add this for DateTime support

namespace EMS.Application.Features.Wallets.Queries.GetWalletSummary
{
    public class WalletBalanceSummary
    {
        public int Id { get; set; }
        public string Name { get; set; } = default!;
        public float Balance { get; set; }
        public string? Description { get; set; }
        public TimePeriod FilterPeriod { get; set; }
        public DateTime? FromDate { get; set; }  
        public DateTime? ToDate { get; set; }   
        public TransactionSummary? Income { get; set; }
        public TransactionSummary? Expense { get; set; }
        public float BalanceByPeriod => (Income?.TotalAmount ?? 0f) - (Expense?.TotalAmount ?? 0f);
    }
}