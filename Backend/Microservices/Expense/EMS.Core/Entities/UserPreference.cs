using EMS.Core.Constants;
using EMS.Core.Entities.Common;
using EMS.Core.Enums;
using EMS.Core.ValueObjects;

namespace EMS.Core.Entities
{
    public class UserPreference: BaseAuditableEntity<int>
    {
        public string UserId { get; set; } = default!;
        public LanguageCode LanguageCode { get; set; } = LanguageCode.EN;
        public CurrencyCode CurrencyCode { get; set; } = CurrencyCode.USD;
        public bool IsOnboardingCompleted { get; set; }
        //public string? Metadata { get; set; }
        public ConfirmationMode ConfirmationMode { get; set; } // confirm the response message of the system
        public string? TimeZoneId { get; set; } = TimeZoneIds.Asia_Ho_Chi_Minh; // IANA time zones

        // Navigations
        public Currency Currency { get; set; } = default!;
    }
}
