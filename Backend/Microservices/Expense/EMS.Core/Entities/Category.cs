using EMS.Core.Entities.Common;
using EMS.Core.Enums;

namespace EMS.Core.Entities
{
    public class Category : BaseAuditableEntity<int>
    {
        public string? UserId { get; set; }
        public string Name { get; set; } = default!;
        public CategoryType Type { get; set; }
        public TransactionType FinancialFlowType { get; set; } // Whether a category is for expense or income
        public Guid? IconId { get; set; }

        // Navigations
        public ICollection<Transaction> Transactions { get; set; } = [];
        public Media? Icon { get; set; }
        public ICollection<ExtractedTransaction> ExtractedTransactions { get; set; } = [];
    }
}
