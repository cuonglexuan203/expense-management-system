using EMS.Core.Entities.Common;
using EMS.Core.Enums;
using EMS.Core.ValueObjects;

namespace EMS.Core.Entities
{
    public class UserPreference: BaseAuditableEntity<int>
    {
        public string UserId { get; set; } = default!;
        public LanguageCode Language { get; set; } = LanguageCode.EN;
        public CurrencyCode CurrencyCode { get; set; } = CurrencyCode.USD;
        public bool IsOnboardingCompleted { get; set; }
        //public string? Metadata { get; set; }
        public ConfirmationMode ConfirmationMode { get; set; } // confirm the response message of the system

        // Navigations
        public Currency Currency { get; set; } = default!;
    }
}
