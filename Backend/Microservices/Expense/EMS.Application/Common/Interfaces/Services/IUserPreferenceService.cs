using EMS.Application.Features.Preferences.Dtos;
using EMS.Core.Constants;

namespace EMS.Application.Common.Interfaces.Services
{
    public interface IUserPreferenceService
    {
        Task<UserPreferenceDto> GetUserPreferenceAsync(CancellationToken cancellationToken = default);
        Task<UserPreferenceDto> GetUserPreferenceByUserIdAsync(string userId);
        Task CreateDefaultUserPreferencesAsync(string userId, string timeZoneId = TimeZoneIds.Asia_Ho_Chi_Minh, CancellationToken cancellationToken = default);
        Task<string?> GetTimeZoneIdAsync (string userId, CancellationToken cancellationToken = default);
        Task<string?> UpdateTimeZoneIdAsync(string userId, string timeZoneId, CancellationToken cancellationToken = default);
    }
}
