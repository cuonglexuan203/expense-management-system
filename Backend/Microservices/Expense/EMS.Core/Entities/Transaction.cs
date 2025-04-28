using EMS.Core.Entities.Common;
using EMS.Core.Enums;
using EMS.Core.ValueObjects;

namespace EMS.Core.Entities
{
    public class Transaction : BaseAuditableEntity<int>
    {
        public string Name { get; set; } = default!;
        public int WalletId { get; set; }
        public int? CategoryId { get; set; }
        public string UserId { get; set; } = default!;
        public CurrencyCode CurrencyCode { get; set; }
        public float Amount { get; set; }
        public TransactionType Type { get; set; }
        public DateTimeOffset? OccurredAt { get; set; }
        public int? CalendarEventId { get; set; }
        //public string? Metadata { get; set; }
        public int? ChatMessageId { get; set; }

        // Navigations
        public ChatMessage? ChatMessage { get; set; }
        public ScheduledEvent? CalendarEvent { get; set; }
        public Category? Category { get; set; }
        public Wallet Wallet { get; set; } = default!;
        public Currency Currency { get; set; } = default!;
        public ExtractedTransaction? ExtractedTransaction { get; set; }

        #region Behaviors
        public static Transaction? CreateFrom(
            ExtractedTransaction extractedTransaction,
            string userId,
            int walletId,
            int? messageId = default)
        {
            if(!extractedTransaction.TryMapToTransaction(out Transaction transaction))
            {
                return null;
            }

            transaction.UserId = userId;
            transaction.WalletId = walletId;
            transaction.ChatMessageId = messageId;
            transaction.ExtractedTransaction = extractedTransaction;

            return transaction;
        }
        #endregion
    }
}
