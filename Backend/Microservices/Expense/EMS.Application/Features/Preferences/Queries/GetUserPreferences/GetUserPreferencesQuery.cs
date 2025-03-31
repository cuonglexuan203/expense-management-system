using EMS.Application.Common.Interfaces.Services;
using EMS.Application.Features.Preferences.Dtos;
using MediatR;
using Microsoft.Extensions.Logging;

namespace EMS.Application.Features.Preferences.Queries.GetUserPreferences
{
    public record GetUserPreferencesQuery : IRequest<UserPreferenceDto>;

    public class GetUserPreferencesQueryHandler : IRequestHandler<GetUserPreferencesQuery, UserPreferenceDto>
    {
        private readonly ILogger<GetUserPreferencesQueryHandler> _logger;
        private readonly ICurrentUserService _currentUserService;
        private readonly IUserPreferenceService _userPreferenceService;

        public GetUserPreferencesQueryHandler(
            ILogger<GetUserPreferencesQueryHandler> logger,
            ICurrentUserService currentUserService,
            IUserPreferenceService userPreferenceService)
        {
            _logger = logger;
            _currentUserService = currentUserService;
            _userPreferenceService = userPreferenceService;
        }
        public async Task<UserPreferenceDto> Handle(GetUserPreferencesQuery request, CancellationToken cancellationToken)
        {
            var userPreferenceDto = await _userPreferenceService.GetUserPreferenceByIdAsync(_currentUserService.Id!);

            return userPreferenceDto;
        }
    }
}
