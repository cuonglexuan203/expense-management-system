using EMS.Core.Entities.Common;
using EMS.Core.Enums;

namespace EMS.Core.Entities
{
    public class UserPreference: BaseAuditableEntity<int>
    {
        public string UserId { get; set; } = default!;
        public Language Language { get; set; } = Language.EN;
        public CurrencyCode Currency { get; set; } = CurrencyCode.USD;
        //public string? Metadata { get; set; }
        public ConfirmationMode ConfirmationMode { get; set; } // confirm the response message of the system

        // Navigations
    }
}
