using EMS.Core.Entities.Common;
using EMS.Core.Enums;

namespace EMS.Core.Entities
{
    public class UserPreference: BaseAuditableEntity<int>
    {
        public string UserId { get; set; } = default!;
        public string Language { get; set; } = default!;
        public Currency Currency { get; set; } = Currency.USD;
        //public string? Metadata { get; set; }
        public bool RequiresConfirmation { get; set; } // confirm the response message of the system

        // Navigations
    }
}
