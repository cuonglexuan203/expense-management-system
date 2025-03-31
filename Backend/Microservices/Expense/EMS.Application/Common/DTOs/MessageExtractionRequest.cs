using EMS.Application.Features.Categories.Dtos;
using EMS.Application.Features.Preferences.Dtos;

namespace EMS.Application.Common.DTOs
{
    public record MessageExtractionRequest(int ChatThreadId, string Query, List<CategoryDto> Categories, UserPreferenceDto UserPreference);
}
