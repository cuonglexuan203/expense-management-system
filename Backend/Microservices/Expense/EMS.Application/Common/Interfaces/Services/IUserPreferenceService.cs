using EMS.Core.Entities;

namespace EMS.Application.Common.Interfaces.Services
{
    public interface IUserPreferenceService
    {
        Task<UserPreference> GetUserPreferenceAsync(CancellationToken cancellationToken = default);
        Task<UserPreference> GetUserPreferenceByIdAsync(string userId);
        Task CreateUserPreferencesAsync(string userId, CancellationToken cancellationToken = default);
    }
}
