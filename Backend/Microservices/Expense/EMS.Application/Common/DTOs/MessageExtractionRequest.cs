using EMS.Application.Features.Preferences.Dtos;

namespace EMS.Application.Common.DTOs
{
    public record MessageExtractionRequest(
        string UserId,
        int ChatThreadId,
        string Message,
        string[] Categories,
        UserPreferenceDto UserPreferences);
}
