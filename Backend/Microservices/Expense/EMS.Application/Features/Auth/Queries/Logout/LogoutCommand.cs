using EMS.Application.Common.Interfaces.Services;
using EMS.Application.Common.Models;
using MediatR;
using Microsoft.Extensions.Logging;

namespace EMS.Application.Features.Auth.Queries.Logout
{
    public record LogoutCommand : IRequest<Result>;

    public class LogoutCommandHandler : IRequestHandler<LogoutCommand, Result>
    {
        private readonly ILogger<LogoutCommand> _logger;
        private readonly ITokenService _tokenService;
        private readonly ICurrentUserService _currentUserService;

        public LogoutCommandHandler(ILogger<LogoutCommand> logger, ITokenService tokenService, ICurrentUserService currentUserService)
        {
            _logger = logger;
            _tokenService = tokenService;
            _currentUserService = currentUserService;
        }

        public async Task<Result> Handle(LogoutCommand request, CancellationToken cancellationToken)
        {
            var userId = _currentUserService.Id;

            if(userId == null)
            {
                throw new UnauthorizedAccessException("Invalid token");
            }

            await _tokenService.RevokeTokenAsync(userId);

            return Result.Success();
        }
    }
}
