using EMS.Application.Common.Interfaces.Services;
using MediatR;
using Microsoft.Extensions.Logging;

namespace EMS.Application.Features.Auth.Commands.RevokeApiKey
{
    public record RevokeApiKeyCommand(Guid Id) : IRequest<bool>;

    public class RevokeApiKeyCommandHandler : IRequestHandler<RevokeApiKeyCommand, bool>
    {
        private readonly ILogger<RevokeApiKeyCommandHandler> _logger;
        private readonly IApiKeyService _apiKeyService;

        public RevokeApiKeyCommandHandler(
            ILogger<RevokeApiKeyCommandHandler> logger,
            IApiKeyService apiKeyService)
        {
            _logger = logger;
            _apiKeyService = apiKeyService;
        }
        public async Task<bool> Handle(RevokeApiKeyCommand request, CancellationToken cancellationToken)
        {
            var result = await _apiKeyService.RevokeApiKeyAsync(request.Id);

            if (result)
            {
                _logger.LogInformation("Successfully revoked API Key with Id {Id}",
                    request.Id);
            }
            else
            {
                _logger.LogError("Failed to revoke API Key with Id {Id}",
                    request.Id);
            }

            return result;
        }
    }
}
