using EMS.Application.Common.Interfaces.Services;
using MediatR;
using Microsoft.Extensions.Logging;

namespace EMS.Application.Features.Auth.Commands.Login
{
    public class LoginCommand : IRequest<LoginDto>
    {
        public string UserName { get; set; } = default!;
        public string Password { get; set; } = default!;
    }

    public class LoginCommandHandler : IRequestHandler<LoginCommand, LoginDto>
    {
        private readonly ILogger<LoginCommand> _logger;
        private readonly IIdentityService _identityService;
        private readonly ITokenService _tokenService;

        public LoginCommandHandler(ILogger<LoginCommand> logger, IIdentityService identityService, ITokenService tokenService)
        {
            _logger = logger;
            _identityService = identityService;
            _tokenService = tokenService;
        }

        public async Task<LoginDto> Handle(LoginCommand request, CancellationToken cancellationToken)
        {
            var (result, userId) = await _identityService.ValidateUserAsync(request.UserName, request.Password);

            if (!result.Succeeded)
            {
                throw new UnauthorizedAccessException(string.Join(", ", result.Errors!));
            }

            var tokenResponse = await _tokenService.GenerateTokensAsync(userId!);
            var user = await _identityService.GetUserAsync(userId!);

            return new(
                user!.Id,
                user.UserName,
                user.FullName,
                user.Email,
                user.Avatar,
                false,
                tokenResponse.AccessToken,
                tokenResponse.RefreshToken,
                tokenResponse.AccessTokenExpiration,
                tokenResponse.RefreshTokenExpiration);
        }
    }
}
