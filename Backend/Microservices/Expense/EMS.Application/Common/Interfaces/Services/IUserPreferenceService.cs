using EMS.Core.Entities;

namespace EMS.Application.Common.Interfaces.Services
{
    public interface IUserPreferenceService
    {
        Task<UserPreference> GetUserPreferenceAsync(CancellationToken cancellationToken = default);
        Task CreateUserPreferencesAsync(string userId, CancellationToken cancellationToken = default);
    }
}
