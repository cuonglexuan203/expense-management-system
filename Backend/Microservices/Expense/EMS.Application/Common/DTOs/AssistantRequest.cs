using EMS.Application.Features.Preferences.Dtos;

namespace EMS.Application.Common.DTOs
{
    public record AssistantRequest(
        string UserId,
        int WalletId,
        int ChatThreadId,
        string? Message,
        string[]? FileUrls,
        string[] Categories,
        UserPreferenceDto UserPreferences);
}
