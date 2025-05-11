using EMS.Application.Common.Interfaces.Services;
using EMS.Application.Features.Profiles.Dtos;
using EMS.Application.Features.Profiles.Services;
using MediatR;
using Microsoft.Extensions.Logging;

namespace EMS.Application.Features.Profiles.Queries
{
    public record GetProfileQuery : IRequest<ProfileVm>;

    public class GetProfileQueryHandler : IRequestHandler<GetProfileQuery, ProfileVm>
    {
        private readonly ILogger<GetProfileQueryHandler> _logger;
        private readonly IProfileService _profileService;
        private readonly ICurrentUserService _user;

        public GetProfileQueryHandler(
            ILogger<GetProfileQueryHandler> logger,
            IProfileService profileService,
            ICurrentUserService user)
        {
            _logger = logger;
            _profileService = profileService;
            _user = user;
        }

        public async Task<ProfileVm> Handle(GetProfileQuery request, CancellationToken cancellationToken)
        {
            var userId = _user.Id!;

            var profileVm = await _profileService.GetUserProfileAsync(userId);

            return profileVm;
        }
    }
}
