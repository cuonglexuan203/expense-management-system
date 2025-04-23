using EMS.Core.Enums;
using EMS.Core.Specifications.Common;

namespace EMS.Core.Specifications
{
    public class ExtractedTransactionSpecParams : PaginationSpecParams
    {
        public string? Name { get; set; } // Transaction name
        public int? CategoryId { get; set; } // Category id
        public TransactionType? Type { get; set; }
    }
}
