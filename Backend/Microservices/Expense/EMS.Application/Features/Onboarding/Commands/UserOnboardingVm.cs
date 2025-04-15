using EMS.Application.Features.Categories.Dtos;
using EMS.Application.Features.Preferences.Dtos;
using EMS.Application.Features.Wallets.Dtos;

namespace EMS.Application.Features.Onboarding.Commands
{
    public record UserOnboardingVm(
        UserPreferenceDto UserPreference,
        List<CategoryDto> Categories,
        WalletDto Wallet);
}
