using EMS.Core.Enums;
using EMS.Core.Specifications.Common;

namespace EMS.Core.Specifications
{
    public class ExtractedTransactionSpecParams : PaginationSpecParams
    {
        public string? Name { get; set; } // Transaction name
        public int? CategoryId { get; set; } // Category id
        public int? NotificationId { get; set; } // Extract from a notification
        public TransactionType? Type { get; set; }
    }
}
