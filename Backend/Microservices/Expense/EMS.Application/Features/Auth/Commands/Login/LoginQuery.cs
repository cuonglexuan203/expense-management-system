using EMS.Application.Common.Interfaces.Services;
using EMS.Application.Common.Models;
using MediatR;
using Microsoft.Extensions.Logging;

namespace EMS.Application.Features.Auth.Commands.Login
{
    public class LoginQuery : IRequest<TokenResponse>
    {
        public string Email { get; set; } = default!;
        public string Password { get; set; } = default!;
    }

    public class LoginQueryHandler : IRequestHandler<LoginQuery, TokenResponse>
    {
        private readonly ILogger<LoginQuery> _logger;
        private readonly IIdentityService _identityService;
        private readonly ITokenService _tokenService;

        public LoginQueryHandler(ILogger<LoginQuery> logger, IIdentityService identityService, ITokenService tokenService)
        {
            _logger = logger;
            _identityService = identityService;
            _tokenService = tokenService;
        }

        public async Task<TokenResponse> Handle(LoginQuery request, CancellationToken cancellationToken)
        {
            var (result, userId) = await _identityService.ValidateUserAsync(request.Email, request.Password);

            if (!result.Succeeded)
            {
                throw new UnauthorizedAccessException(string.Join(", ", result.Errors!));
            }

            var tokenResponse = await _tokenService.GenerateTokensAsync(userId!);

            return tokenResponse;
        }
    }
}
