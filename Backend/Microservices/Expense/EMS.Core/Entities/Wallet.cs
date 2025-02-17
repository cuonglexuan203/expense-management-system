using EMS.Core.Entities.Common;

namespace EMS.Core.Entities
{
    public class Wallet : BaseEntity<int>
    {
        public Guid UserId { get; set; }
        public string Name { get; set; } = default!;
        public float Balance { get; set; }
        public string? Description { get; set; }

        // Navigations 
        public ICollection<FinancialGoal> FinancialGoals { get; set; } = [];
        public ICollection<CalendarEvent> CalendarEvents { get; set; } = [];
        public ICollection<Transaction> Transactions { get; set; } = [];
    }
}
