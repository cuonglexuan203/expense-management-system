using EMS.Application.Features.Preferences.Dtos;

namespace EMS.Application.Common.Interfaces.Services
{
    public interface IUserPreferenceService
    {
        Task<UserPreferenceDto> GetUserPreferenceAsync(CancellationToken cancellationToken = default);
        Task<UserPreferenceDto> GetUserPreferenceByUserIdAsync(string userId);
        Task CreateDefaultUserPreferencesAsync(string userId, CancellationToken cancellationToken = default);
        Task<string?> GetTimeZoneIdAsync (string userId, CancellationToken cancellationToken = default);
    }
}
