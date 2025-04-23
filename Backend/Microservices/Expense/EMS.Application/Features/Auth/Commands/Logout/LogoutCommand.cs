using EMS.Application.Common.Interfaces.Services;
using EMS.Application.Common.Models;
using EMS.Application.Features.DeviceTokens.Services;
using MediatR;
using Microsoft.Extensions.Logging;

namespace EMS.Application.Features.Auth.Commands.Logout
{
    // NOTE: Revoke refresh token + Remove FCM registration token
    public record LogoutCommand(string FcmToken) : IRequest<Result>;

    public class LogoutCommandHandler : IRequestHandler<LogoutCommand, Result>
    {
        private readonly ILogger<LogoutCommand> _logger;
        private readonly ITokenService _tokenService;
        private readonly ICurrentUserService _currentUserService;
        private readonly IDeviceTokenService _dtService;

        public LogoutCommandHandler(
            ILogger<LogoutCommand> logger,
            ITokenService tokenService,
            ICurrentUserService currentUserService,
            IDeviceTokenService dtService)
        {
            _logger = logger;
            _tokenService = tokenService;
            _currentUserService = currentUserService;
            _dtService = dtService;
        }

        public async Task<Result> Handle(LogoutCommand request, CancellationToken cancellationToken)
        {
            var userId = _currentUserService.Id;

            if (userId == null)
            {
                throw new UnauthorizedAccessException("Invalid token");
            }

            await _tokenService.RevokeTokenAsync(userId);

            await _dtService.RemoveDeviceTokenAsync(userId, request.FcmToken);

            return Result.Success();
        }
    }
}
