using EMS.Core.Entities.Common;
using EMS.Core.Enums;

namespace EMS.Core.Entities
{
    public class ChatExtraction : BaseAuditableEntity<int>
    {
        public int ChatMessageId { get; set; }
        public ExtractionType ExtractionType { get; set; }
        public string? ExtractedData { get; set; }

        // Navigations
        public ChatMessage ChatMessage { get; set; } = default!;
        public ICollection<ExtractedTransaction> ExtractedTransactions { get; set; } = [];
    }
}
