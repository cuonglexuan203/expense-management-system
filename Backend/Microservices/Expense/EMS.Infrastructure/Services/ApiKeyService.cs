using AutoMapper;
using AutoMapper.QueryableExtensions;
using EMS.Application.Common.DTOs;
using EMS.Application.Common.Extensions;
using EMS.Application.Common.Interfaces.DbContext;
using EMS.Application.Common.Interfaces.Services;
using EMS.Core.Entities;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Logging;
using System.Security.Cryptography;
using System.Text;

namespace EMS.Infrastructure.Services
{
    public class ApiKeyService : IApiKeyService
    {
        private readonly ILogger<ApiKeyService> _logger;
        private readonly IApplicationDbContext _context;
        private readonly IMapper _mapper;

        public ApiKeyService(
            ILogger<ApiKeyService> logger,
            IApplicationDbContext context,
            IMapper mapper)
        {
            _logger = logger;
            _context = context;
            _mapper = mapper;
        }
        public async Task<ApiKeyCreationResultDto> CreateApiKeyAsync(ApiKeyCreationDto request, string ownerId)
        {
            var (plainTextKey, hashedKey) = GenerateApiKey();

            var apiKey = new ApiKey(
                request.Name,
                hashedKey,
                ownerId,
                request.Description,
                request.ExpiresAt);

            if (request.Scopes != null)
            {
                foreach (var scope in request.Scopes)
                {
                    apiKey.AddScope(new(scope));
                }
            }

            _context.ApiKeys.Add(apiKey);
            await _context.SaveChangesAsync();

            return new()
            {
                Id = apiKey.Id,
                Name = apiKey.Name,
                Key = plainTextKey, // Plain text key returned only once
                CreatedAt = apiKey.CreatedAt,
                ExpiresAt = apiKey.ExpiresAt,
                Scopes = apiKey.Scopes.Select(s => s.Scope)
            };
        }

        /// <summary>
        /// Only for Application Initialization
        /// </summary>
        /// <param name="requests">Tuple contains API Key and plain text key</param>
        /// <param name="ownerId">Owner Id</param>
        /// <returns>Created API Keys</returns>
        public async Task<IEnumerable<ApiKeyCreationResultDto>> CreateApiKeysAsync(
            IEnumerable<(ApiKeyCreationDto ApiKeyCreationDto, string PlainTextKey)> requests,
            string? ownerId)
        {
            var result = new List<ApiKeyCreationResultDto>();
            foreach(var request in requests)
            {
                var plainTextKey = request.PlainTextKey;
                var hashedKey = HashApiKey(request.PlainTextKey);

                var apiKey = new ApiKey(
                    request.ApiKeyCreationDto.Name,
                    hashedKey,
                    ownerId,
                    request.ApiKeyCreationDto.Description,
                    request.ApiKeyCreationDto.ExpiresAt);

                if (request.ApiKeyCreationDto.Scopes != null)
                {
                    foreach (var scope in request.ApiKeyCreationDto.Scopes)
                    {
                        apiKey.AddScope(new(scope));
                    }
                }

                _context.ApiKeys.Add(apiKey);

                result.Add(new()
                {
                    Id = apiKey.Id,
                    Name = apiKey.Name,
                    Key = plainTextKey,
                    CreatedAt = apiKey.CreatedAt,
                    ExpiresAt = apiKey.ExpiresAt,
                    Scopes = apiKey.Scopes.Select(s => s.Scope)
                });
            }

            await _context.SaveChangesAsync();

            return result;
        }

        public async Task<ApiKeyDto?> GetApiKeyByIdAsync(Guid id)
        {
            var apiKeyDto = await _context.ApiKeys
                .AsNoTracking()
                .Include(e => e.Scopes.Where(s => !s.IsDeleted))
                .Where(e => e.Id == id && !e.IsDeleted)
                .ProjectTo<ApiKeyDto>(_mapper.ConfigurationProvider)
                .FirstOrDefaultAsync();

            return apiKeyDto;
        }

        public async Task<IEnumerable<ApiKeyDto>> GetApiKeysByOwnerIdAsync(string ownerId)
        {
            var apiKeyDtoList = await _context.ApiKeys
                .AsNoTracking()
                .Include(e => e.Scopes.Where(s => !s.IsDeleted))
                .Where(e => e.OwnerId == ownerId && !e.IsDeleted)
                .ProjectToListAsync<ApiKeyDto>(_mapper.ConfigurationProvider);

            return apiKeyDtoList;
        }
        public async Task<bool> RevokeApiKeyAsync(Guid id)
        {
            var apiKey = await _context.ApiKeys
                .FirstOrDefaultAsync(e => e.Id == id && !e.IsDeleted);

            if (apiKey == null)
            {
                return false;
            }

            apiKey.Deactivate();
            await _context.SaveChangesAsync();

            return true;
        }
        public async Task<bool> ValidateApiKeyAsync(string apiKey)
        {
            if (string.IsNullOrEmpty(apiKey))
            {
                return false;
            }

            try
            {
                var entity = await GetApiKeyDetailsFromPlainTextAsync(apiKey);

                if (entity == null)
                {
                    return false;
                }

                entity.UpdateLastUsed();
                await _context.SaveChangesAsync();

                return true;
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error validating API key");
                return false;
            }
        }

        public async Task<ApiKey?> GetApiKeyDetailsFromPlainTextAsync(string plainTextKey)
        {
            if (string.IsNullOrEmpty(plainTextKey))
            {
                return default;
            }

            string hashedKey = HashApiKey(plainTextKey);

            var apiKey = await _context.ApiKeys
                .Include(e => e.Scopes.Where(e => !e.IsDeleted))
                .FirstOrDefaultAsync(e => e.Key == hashedKey && !e.IsDeleted);

            return apiKey;
        }



        private (string plainTextKey, string hashedKey) GenerateApiKey()
        {
            using var rng = RandomNumberGenerator.Create();
            var keyBytes = new byte[32];
            rng.GetBytes(keyBytes);

            // URL-safe base64 string
            var base64 = Convert.ToBase64String(keyBytes)
                .Replace('+', '-')
                .Replace('/', '-')
                .TrimEnd('=');

            var plainTextKey = $"sk_{base64}"; // prefix for identification
            var hashedKey = HashApiKey(plainTextKey);

            return (plainTextKey, hashedKey);
        }

        private string HashApiKey(string plainTextKey)
        {
            var hashedBytes = SHA256.HashData(Encoding.UTF8.GetBytes(plainTextKey));
            return Convert.ToBase64String(hashedBytes);
        }
    }
}
