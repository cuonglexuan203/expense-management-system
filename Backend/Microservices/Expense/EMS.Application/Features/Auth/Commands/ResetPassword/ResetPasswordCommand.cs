using EMS.Application.Common.Interfaces.Services;
using EMS.Application.Common.Models;
using MediatR;
using Microsoft.Extensions.Logging;

namespace EMS.Application.Features.Auth.Commands.ResetPassword
{
    public record ResetPasswordCommand(
        string Email,
        string Token,
        string NewPassword,
        string ConfirmPassword) : IRequest<Result>;

    public class ResetPasswordCommandHandler : IRequestHandler<ResetPasswordCommand, Result>
    {
        private readonly ILogger<ResetPasswordCommandHandler> _logger;
        private readonly IIdentityService _identityService;

        public ResetPasswordCommandHandler(
            ILogger<ResetPasswordCommandHandler> logger,
            IIdentityService identityService)
        {
            _logger = logger;
            _identityService = identityService;
        }
        public async Task<Result> Handle(ResetPasswordCommand request, CancellationToken cancellationToken)
        {
            var result = await _identityService.ResetPasswordAsync(request.Email, request.Token, request.NewPassword);

            return result;
        }
    }
}
