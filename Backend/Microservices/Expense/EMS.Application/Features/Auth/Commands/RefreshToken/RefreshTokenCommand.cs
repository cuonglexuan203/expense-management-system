using EMS.Application.Common.Interfaces.Services;
using EMS.Application.Common.Models;
using MediatR;
using Microsoft.Extensions.Logging;

namespace EMS.Application.Features.Auth.Commands.RefreshToken
{
    public class RefreshTokenCommand : IRequest<TokenResponse>
    {
        public string AccessToken { get; set; } = default!;
        public string RefreshToken { get; set; } = default!;
    }

    public class RefreshTokenCommandHandler : IRequestHandler<RefreshTokenCommand, TokenResponse>
    {
        private readonly ILogger<RefreshTokenCommand> _logger;
        private readonly ITokenService _tokenService;

        public RefreshTokenCommandHandler(ILogger<RefreshTokenCommand> logger, ITokenService tokenService)
        {
            _logger = logger;
            _tokenService = tokenService;
        }

        public async Task<TokenResponse> Handle(RefreshTokenCommand request, CancellationToken cancellationToken)
        {
            var tokenResponse = await _tokenService.RefreshTokenAsync(request.AccessToken, request.RefreshToken);

            return tokenResponse;
        }
    }
}
