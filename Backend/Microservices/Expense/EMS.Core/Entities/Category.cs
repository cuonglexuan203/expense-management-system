using EMS.Core.Entities.Common;
using EMS.Core.Enums;

namespace EMS.Core.Entities
{
    public class Category: BaseEntity<int>
    {
        public Guid UserId { get; set; }
        public string Name { get; set; } = default!;
        public bool IsDefault { get; set; } = true;
        public TransactionType Type { get; set; } = TransactionType.Expense;
        public string? Description { get; set; }

        // Navigations
        public ICollection<Transaction> Transactions { get; set; } = [];
    }
}
