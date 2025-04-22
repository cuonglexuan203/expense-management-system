using EMS.Application.Features.Preferences.Dtos;

namespace EMS.Application.Common.DTOs
{
    // NOTE: Only use for the extraction route (extract from text)
    public record MessageAnalysisRequest(
        string UserId,
        int ChatThreadId,
        string Message,
        string[] Categories,
        UserPreferenceDto UserPreferences);
}
