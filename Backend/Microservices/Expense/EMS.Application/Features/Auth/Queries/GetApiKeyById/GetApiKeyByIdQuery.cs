using EMS.Application.Common.DTOs;
using EMS.Application.Common.Exceptions;
using EMS.Application.Common.Interfaces.Services;
using MediatR;
using Microsoft.Extensions.Logging;

namespace EMS.Application.Features.Auth.Queries.GetApiKeyById
{
    public record GetApiKeyByIdQuery(Guid Id) : IRequest<ApiKeyDto>;

    public class GetApiKeyByIdQueryHandler : IRequestHandler<GetApiKeyByIdQuery, ApiKeyDto>
    {
        private readonly ILogger<GetApiKeyByIdQuery> _logger;
        private readonly IApiKeyService _apiKeyService;

        public GetApiKeyByIdQueryHandler(
            ILogger<GetApiKeyByIdQuery> logger,
            IApiKeyService apiKeyService)
        {
            _logger = logger;
            _apiKeyService = apiKeyService;
        }
        public async Task<ApiKeyDto> Handle(GetApiKeyByIdQuery request, CancellationToken cancellationToken)
        {
            var apiKey = await _apiKeyService.GetApiKeyByIdAsync(request.Id)
                ?? throw new NotFoundException($"Api Key with Id {request.Id} not found.");

            return apiKey;
        }
    }
}
