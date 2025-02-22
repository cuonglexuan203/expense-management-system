using EMS.Core.Entities.Common;
using EMS.Core.Enums;

namespace EMS.Core.Entities
{
    public class CalendarEvent : BaseAuditableEntity<int>
    {
        public string UserId { get; set; } = default!;
        public int WalletId { get; set; }
        public string Title { get; set; } = default!;
        public string? Description { get; set; }
        public RecurrenceInterval Interval { get; set; }
        public bool IsActive { get; set; } = true;
        public DateTimeOffset StartDate { get; set; }
        public DateTimeOffset? EndDate { get; set; }
        public string? Location { get; set; }
        public float? EstimatedAmount { get; set; }
        public TransactionType? TransactionType { get; set; }

        // Navigations
        public ICollection<Transaction> Transactions { get; set; } = [];
        public Wallet Wallet { get; set; } = default!;
    }
}
