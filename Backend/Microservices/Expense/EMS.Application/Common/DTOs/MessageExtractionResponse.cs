using EMS.Application.Features.Chats.Common.Dtos;
using EMS.Core.Enums;

namespace EMS.Application.Common.DTOs
{
    public class MessageExtractionResponse
    {
        public string Introduction { get; set; } = default!;
        public TransactionType? TransactionType { get; set; }
        public ExtractedTransactionDto[] CategorizedItems { get; set; } = [];
        public float? TotalExpenses { get; set; }
        public float? TotalIncome { get; set; }
    }
}
