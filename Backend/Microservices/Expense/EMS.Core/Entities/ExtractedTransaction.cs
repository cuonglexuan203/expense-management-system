using EMS.Core.Entities.Common;
using EMS.Core.Enums;
using EMS.Core.ValueObjects;

namespace EMS.Core.Entities
{
    public class ExtractedTransaction : BaseAuditableEntity<int>
    {
        public int ChatExtractionId { get; set; }
        public int ChatMessageId { get; set; }
        public int CategoryId { get; set; }
        public int TransactionId { get; set; }
        public string Name { get; set; } = default!;
        public float Amount { get; set; }
        public TransactionType Type { get; set; }
        public DateTimeOffset OccurredAt { get; set; }
        public ConfirmationMode ConfirmationMode { get; set; }
        public ConfirmationStatus ConfirmationStatus { get; set; }

        // Navigations
        public ChatMessage ChatMessage { get; set; } = default!;
        public ChatExtraction ChatExtraction { get; set; } = default!;
        public Transaction? Transaction { get; set; }
        public CurrencyCode CurrencyCode { get; set; } = default!;
        public Category? Category { get; set; }
    }
}
