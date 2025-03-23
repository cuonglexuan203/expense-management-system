using EMS.Application.Common.Mappings;
using EMS.Core.Entities;
using EMS.Core.Enums;

namespace EMS.Application.Features.Chats.Common.Dtos
{
    public class ExtractedTransactionDto : IMapFrom<ExtractedTransaction>
    {
        public int ChatExtractionId { get; set; }
        public int ChatMessageId { get; set; }
        public string? Category { get; set; }
        public int TransactionId { get; set; }
        public string Name { get; set; } = default!;
        public float Amount { get; set; }
        public TransactionType Type { get; set; }
        public DateTimeOffset OccurredAt { get; set; }
        public ConfirmationMode ConfirmationMode { get; set; }
        public ConfirmationStatus ConfirmationStatus { get; set; }
        public DateTimeOffset CreatedAt { get; set; }
    }
}
