using EMS.Core.Enums;

namespace EMS.Application.Common.DTOs
{
    public class FinancialEventPayload
    {
        public int WalletId { get; set; }
        public int? CategoryId { get; set; }
        public float Amount { get; set; }
        public TransactionType Type { get; set; }
    }
}
