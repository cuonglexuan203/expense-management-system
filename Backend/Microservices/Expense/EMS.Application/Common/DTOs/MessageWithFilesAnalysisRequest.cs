using EMS.Application.Features.Preferences.Dtos;

namespace EMS.Application.Common.DTOs
{
    // NOTE: Only use for the extraction route (extract from text, image, audio)
    public record MessageWithFilesAnalysisRequest(
    string UserId,
    int ChatThreadId,
    string Message,
    string[] FileUrls,
    string[] Categories,
    UserPreferenceDto UserPreferences);
}
