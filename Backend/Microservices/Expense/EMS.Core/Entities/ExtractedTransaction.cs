using EMS.Core.Entities.Common;
using EMS.Core.Enums;
using EMS.Core.ValueObjects;

namespace EMS.Core.Entities
{
    public class ExtractedTransaction : BaseAuditableEntity<int>
    {
        public string UserId { get; set; } = default!;
        public int? ChatExtractionId { get; set; } // NOTE: Null in case of notification extraction
        //public int ChatMessageId { get; set; }
        public int? CategoryId { get; set; }
        public int? TransactionId { get; set; }
        public CurrencyCode CurrencyCode { get; set; }
        public string Name { get; set; } = default!;
        public float Amount { get; set; }
        public TransactionType Type { get; set; }
        public DateTimeOffset OccurredAt { get; set; }
        public ConfirmationMode ConfirmationMode { get; set; }
        public ConfirmationStatus ConfirmationStatus { get; set; }

        #region Navigations
        //public ChatMessage ChatMessage { get; set; } = default!;
        public virtual IUser<string> User { get; set; } = default!;
        public ChatExtraction? ChatExtraction { get; set; } = default!;
        public Transaction? Transaction { get; set; }
        public Currency Currency { get; set; } = default!;
        public Category? Category { get; set; }
        #endregion

        #region Behaviors
        public bool TryMapToTransaction()
        {
            return TryMapToTransaction(out var result);
        }

        public bool TryMapToTransaction(out Transaction transaction)
        {
            transaction = new();

            if (ConfirmationStatus != ConfirmationStatus.Confirmed)
            {
                return false;
            }

            transaction.UserId = UserId;
            transaction.Name = Name;
            transaction.CategoryId = CategoryId;
            transaction.CurrencyCode = CurrencyCode;
            transaction.Amount = Amount;
            transaction.Type = Type;
            transaction.OccurredAt = OccurredAt;

            return true;
        }
        #endregion
    }
}
