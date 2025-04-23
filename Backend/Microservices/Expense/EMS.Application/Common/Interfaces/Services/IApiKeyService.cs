using EMS.Application.Common.DTOs;
using EMS.Core.Entities;

namespace EMS.Application.Common.Interfaces.Services
{
    public interface IApiKeyService
    {
        Task<ApiKeyCreationResultDto> CreateApiKeyAsync(ApiKeyCreationDto request, string ownerId);
        Task<ApiKeyDto?> GetApiKeyByIdAsync(Guid id);
        Task<IEnumerable<ApiKeyDto>> GetApiKeysByOwnerIdAsync(string ownerId);
        Task<bool> RevokeApiKeyAsync(Guid id);
        Task<bool> ValidateApiKeyAsync(string apiKey);
        Task<ApiKey?> GetApiKeyDetailsFromPlainTextAsync(string plainTextKey);

        // Only for application initialization
        Task<IEnumerable<ApiKeyCreationResultDto>> CreateApiKeysAsync(
            IEnumerable<(ApiKeyCreationDto ApiKeyCreationDto, string PlainTextKey)> requests,
            string? ownerId);
    }
}
