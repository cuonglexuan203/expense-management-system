using EMS.Application.Common.Interfaces.Services;
using EMS.Application.Common.Models;
using MediatR;
using Microsoft.Extensions.Logging;

namespace EMS.Application.Features.Auth.Commands.ChangePassword
{
    public record ChangePasswordCommand(
        string CurrentPassword,
        string NewPassword) : IRequest<Result>;

    public class ChangePasswordCommandHandler : IRequestHandler<ChangePasswordCommand, Result>
    {
        private readonly ILogger<ChangePasswordCommandHandler> _logger;
        private readonly IIdentityService _identityService;
        private readonly ICurrentUserService _user;

        public ChangePasswordCommandHandler(
            ILogger<ChangePasswordCommandHandler> logger,
            IIdentityService identityService,
            ICurrentUserService user)
        {
            _logger = logger;
            _identityService = identityService;
            _user = user;
        }
        public async Task<Result> Handle(ChangePasswordCommand request, CancellationToken cancellationToken)
        {
            var userId = _user.Id!;

            var result = await _identityService.ChangePasswordAsync(userId, request.CurrentPassword, request.NewPassword);

            return result;
        }
    }
}
