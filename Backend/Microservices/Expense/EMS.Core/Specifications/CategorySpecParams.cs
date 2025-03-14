using EMS.Core.Enums;
using EMS.Core.Specifications.Common;

namespace EMS.Core.Specifications
{
    public class CategorySpecParams : PaginationSpecParams
    {
        public string? Name { get; set; }
        public CategoryType? Type { get; set; }
        public TransactionType? FinancialFlowType { get; set; }
    }
}
