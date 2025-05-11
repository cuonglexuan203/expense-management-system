using EMS.Application.Common.Interfaces.Services;
using EMS.Application.Common.Utils;
using EMS.Application.Features.Profiles.Dtos;
using EMS.Application.Features.Profiles.Services;
using MediatR;
using Microsoft.Extensions.Logging;

namespace EMS.Application.Features.Profiles.Commands.UpdateProfile
{
    //[UserInvalidateCache(CacheKeyGenerator.GeneralKeys.UserPreference)]
    public record UpdateProfileCommand(
        string? FullName,
        string? Email,
        string? Avatar,
        string? TimeZoneId) : IRequest<ProfileVm>;

    public class UpdateProfileCommandHandler : IRequestHandler<UpdateProfileCommand, ProfileVm>
    {
        private readonly ILogger<UpdateProfileCommandHandler> _logger;
        private readonly ICurrentUserService _user;
        private readonly IProfileService _profileService;
        private readonly IDistributedCacheService _cacheService;

        public UpdateProfileCommandHandler(
            ILogger<UpdateProfileCommandHandler> logger,
            ICurrentUserService user,
            IProfileService profileService,
            IDistributedCacheService cacheService)
        {
            _logger = logger;
            _user = user;
            _profileService = profileService;
            _cacheService = cacheService;
        }

        public async Task<ProfileVm> Handle(UpdateProfileCommand request, CancellationToken cancellationToken)
        {
            var userId = _user.Id!;

            await _cacheService.RemoveAsync(CacheKeyGenerator.GenerateForUser(CacheKeyGenerator.GeneralKeys.UserPreference, userId));

            var profileVm = await _profileService.UpdateProfileAsync(userId, request, cancellationToken);

            return profileVm;
        }
    }
}
