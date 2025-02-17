using EMS.Core.Entities.Common;
using EMS.Core.Enums;

namespace EMS.Core.Entities
{
    public class Transaction : BaseEntity<int>
    {
        public int WalletId { get; set; }
        public int? CategoryId { get; set; }
        public Guid UserId { get; set; }
        public float Amount { get; set; }
        public string? Description { get; set; }
        public TransactionType Type { get; set; }
        public int? CalendarEventId { get; set; }
        public string? Metadata { get; set; }
        public int? ChatMessageId { get; set; }

        // Navigations
        public ChatMessage? ChatMessage { get; set; }
        public CalendarEvent? CalendarEvent { get; set; }
        public Category? Category { get; set; }
        public Wallet Wallet { get; set; } = default!;

    }
}
