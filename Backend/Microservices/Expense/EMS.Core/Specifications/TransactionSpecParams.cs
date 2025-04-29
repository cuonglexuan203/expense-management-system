using EMS.Core.Enums;
using EMS.Core.Specifications.Common;

namespace EMS.Core.Specifications
{
    public class TransactionSpecParams : PaginationSpecParams
    {
        public TimePeriod? Period { get; set; } = TimePeriod.AllTime;
        public string? Name { get; set; } // Transaction name
        public int? WalletId { get; set; } // Wallet id
        public DateTime? FromDate { get; set; }
        public DateTime? ToDate { get; set; }
        public int? CategoryId { get; set; } // Category id
        public TransactionType? Type { get; set; }
    }
}
