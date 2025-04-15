using EMS.Application.Common.Interfaces.Services;
using EMS.Application.Features.Onboarding.Services;
using MediatR;
using Microsoft.Extensions.Logging;

namespace EMS.Application.Features.Onboarding.Queries.GetOnboardingStatus
{
    public record GetOnboardingStatusQuery : IRequest<bool>;

    public class GetOnboardingStatusQueryHandler : IRequestHandler<GetOnboardingStatusQuery, bool>
    {
        private readonly ILogger<GetOnboardingStatusQueryHandler> _logger;
        private readonly IOnboardingService _onboardingService;
        private readonly ICurrentUserService _currentUserService;

        public GetOnboardingStatusQueryHandler(
            ILogger<GetOnboardingStatusQueryHandler> logger,
            IOnboardingService onboardingService,
            ICurrentUserService currentUserService)
        {
            _logger = logger;
            _onboardingService = onboardingService;
            _currentUserService = currentUserService;
        }
        public async Task<bool> Handle(GetOnboardingStatusQuery request, CancellationToken cancellationToken)
        {
            var userId = _currentUserService.Id!;
            var isOnboardingCompleted = await _onboardingService.IsOnboardingCompleted(userId);

            return isOnboardingCompleted;
        }
    }
}
