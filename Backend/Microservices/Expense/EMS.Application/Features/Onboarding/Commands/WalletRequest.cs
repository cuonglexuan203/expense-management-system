namespace EMS.Application.Features.Onboarding.Commands
{
    public record WalletRequest(string Name, float Balance, string? Description);
}
