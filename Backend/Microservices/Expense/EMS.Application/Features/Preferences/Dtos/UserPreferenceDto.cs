using EMS.Application.Common.Mappings;
using EMS.Core.Entities;
using EMS.Core.Enums;

namespace EMS.Application.Features.Preferences.Dtos
{
    public class UserPreferenceDto : IMapFrom<UserPreference>
    {
        public string UserId { get; set; } = default!;
        public Language Language { get; set; }
        public CurrencyCode CurrencyCode { get; set; }
        public ConfirmationMode ConfirmationMode { get; set; }
    }
}
