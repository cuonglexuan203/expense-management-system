using EMS.Core.Enums;
using EMS.Core.Specifications.Common;

namespace EMS.Core.Specifications
{
    public class TransactionSpecParams : PaginationSpecParams
    {
        public TimePeriod? Period { get; set; } = TimePeriod.AllTime;
        public string? Name { get; set; } // Transaction name
        public string? Wallet { get; set; } // Wallet name
        public string? Category { get; set; } // Category name
        public TransactionType? Type { get; set; }
    }
}
