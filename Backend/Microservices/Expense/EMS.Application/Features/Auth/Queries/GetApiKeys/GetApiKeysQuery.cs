using EMS.Application.Common.DTOs;
using EMS.Application.Common.Interfaces.Services;
using MediatR;
using Microsoft.Extensions.Logging;

namespace EMS.Application.Features.Auth.Queries.GetApiKeys
{
    public record GetApiKeysQuery : IRequest<IEnumerable<ApiKeyDto>>;

    public class GetApiKeysQueryHandler : IRequestHandler<GetApiKeysQuery, IEnumerable<ApiKeyDto>>
    {
        private readonly ILogger<GetApiKeysQueryHandler> _logger;
        private readonly IApiKeyService _apiKeyService;
        private readonly ICurrentUserService _currentUserService;

        public GetApiKeysQueryHandler(
            ILogger<GetApiKeysQueryHandler> logger,
            IApiKeyService apiKeyService,
            ICurrentUserService currentUserService)
        {
            _logger = logger;
            _apiKeyService = apiKeyService;
            _currentUserService = currentUserService;
        }

        public async Task<IEnumerable<ApiKeyDto>> Handle(GetApiKeysQuery request, CancellationToken cancellationToken)
        {
            var ownerId = _currentUserService.Id!;

            var result = await _apiKeyService.GetApiKeysByOwnerIdAsync(ownerId);

            return result;
        }
    }
}
