using EMS.Application.Features.Onboarding.Commands;
using EMS.Application.Features.Wallets.Dtos;

namespace EMS.Application.Features.Onboarding.Services
{
    public interface IOnboardingService
    {
        Task<UserOnboardingVm> CompleteUserOnboarding(
            string userId,
            string languageCode,
            string currencyCode,
            List<int> selectedCategoryIds,
            WalletDto wallet);

        Task<bool> IsOnboardingCompleted(string userId);
    }
}
