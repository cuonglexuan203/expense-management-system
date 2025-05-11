using EMS.Application.Features.Profiles.Commands.UpdateProfile;
using EMS.Application.Features.Profiles.Dtos;

namespace EMS.Application.Features.Profiles.Services
{
    public interface IProfileService
    {
        Task<ProfileVm> GetUserProfileAsync(string userId, CancellationToken cancellationToken = default);
        Task<ProfileVm> UpdateProfileAsync(string userId, UpdateProfileCommand values, CancellationToken cancellationToken = default);
    }
}
