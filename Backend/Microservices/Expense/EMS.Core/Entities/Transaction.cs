using EMS.Core.Entities.Common;
using EMS.Core.Enums;

namespace EMS.Core.Entities
{
    public class Transaction : BaseAuditableEntity<int>
    {
        public string Name { get; set; } = default!;
        public int WalletId { get; set; }
        public int? CategoryId { get; set; }
        public string UserId { get; set; } = default!;
        public float Amount { get; set; }
        public TransactionType Type { get; set; }
        public DateTimeOffset? OccurredAt { get; set; }
        public int? CalendarEventId { get; set; }
        //public string? Metadata { get; set; }
        public int? ChatMessageId { get; set; }

        // Navigations
        public ChatMessage? ChatMessage { get; set; }
        public CalendarEvent? CalendarEvent { get; set; }
        public Category? Category { get; set; }
        public Wallet Wallet { get; set; } = default!;

    }
}
