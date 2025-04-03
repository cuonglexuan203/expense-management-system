using EMS.Application.Features.Preferences.Dtos;

namespace EMS.Application.Common.DTOs
{
    public record MessageWithFilesExtractionRequest(
    string UserId,
    int ChatThreadId,
    string Message,
    string[] FileUrls,
    string[] Categories,
    UserPreferenceDto UserPreferences);
}
