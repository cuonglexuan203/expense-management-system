using EMS.Application.Common.DTOs;
using EMS.Application.Common.Interfaces.Services;
using MediatR;
using Microsoft.Extensions.Logging;
using System.Linq;

namespace EMS.Application.Features.Auth.Commands.CreateApiKey
{
    public record CreateApiKeyCommand(ApiKeyCreationDto ApiKeyCreationDto) : IRequest<ApiKeyCreationResultDto>;

    public class CreateApiKeyCommandHandler : IRequestHandler<CreateApiKeyCommand, ApiKeyCreationResultDto>
    {
        private readonly ILogger<CreateApiKeyCommandHandler> _logger;
        private readonly IApiKeyService _apiKeyService;
        private readonly ICurrentUserService _currentUserService;

        public CreateApiKeyCommandHandler(
            ILogger<CreateApiKeyCommandHandler> logger,
            IApiKeyService apiKeyService,
            ICurrentUserService currentUserService)
        {
            _logger = logger;
            _apiKeyService = apiKeyService;
            _currentUserService = currentUserService;
        }
        public async Task<ApiKeyCreationResultDto> Handle(CreateApiKeyCommand request, CancellationToken cancellationToken)
        {
            try
            {
                var ownerId = _currentUserService.Id!;

                var result = await _apiKeyService.CreateApiKeyAsync(request.ApiKeyCreationDto, ownerId);

                _logger.LogInformation("API Key {Name} created with Id {Id}: expires at {ExpiresAt}, scopes {Scopes}",
                    result.Name,
                    result.Id,
                    result.CreatedAt,
                    string.Join(", ", result.Scopes));

                return result;
            }
            catch (Exception ex)
            {
                _logger.LogError("Error creating API key: {msg}", ex.Message);

                throw;
            }
        }
    }
}
