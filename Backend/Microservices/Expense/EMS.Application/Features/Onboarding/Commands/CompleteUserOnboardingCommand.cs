using EMS.Application.Common.Interfaces.Services;
using EMS.Application.Features.Onboarding.Services;
using MediatR;
using Microsoft.Extensions.Logging;

namespace EMS.Application.Features.Onboarding.Commands
{
    public record CompleteUserOnboardingCommand(
        string LanguageCode,
        string CurrencyCode,
        List<int> SelectedCategoryIds,
        WalletRequest Wallet) : IRequest<UserOnboardingVm>;

    public class CompleteUserOnboardingCommandHandler : IRequestHandler<CompleteUserOnboardingCommand, UserOnboardingVm>
    {
        private readonly ILogger<CompleteUserOnboardingCommandHandler> _logger;
        private readonly ICurrentUserService _currentUserService;
        private readonly IOnboardingService _onboardingService;

        public CompleteUserOnboardingCommandHandler(
            ILogger<CompleteUserOnboardingCommandHandler> logger,
            ICurrentUserService currentUserService,
            IOnboardingService onboardingService)
        {
            _logger = logger;
            _currentUserService = currentUserService;
            _onboardingService = onboardingService;
        }
        public async Task<UserOnboardingVm> Handle(CompleteUserOnboardingCommand request, CancellationToken cancellationToken)
        {
            var userId = _currentUserService.Id!;
            var result = await _onboardingService.CompleteUserOnboarding(
                userId,
                request.LanguageCode,
                request.CurrencyCode,
                request.SelectedCategoryIds,
                new()
                {
                    Name = request.Wallet.Name,
                    Balance = request.Wallet.Balance,
                    Description = request.Wallet.Description,
                });

            _logger.LogInformation("Complete User (ID: {UserId}) Onboarding Successfully", userId);

            return result;
        }
    }
}
