using EMS.Application.Features.Preferences.Dtos;

namespace EMS.Application.Features.Profiles.Dtos
{
    public class ProfileVm
    {
        public UserDto User { get; set; } = default!;
        public UserPreferenceDto UserPreference { get; set; } = default!;
    }
}
