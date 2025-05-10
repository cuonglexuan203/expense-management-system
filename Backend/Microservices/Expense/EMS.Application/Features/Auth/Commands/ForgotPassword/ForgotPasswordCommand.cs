using EMS.Application.Common.Interfaces.Services;
using EMS.Application.Common.Interfaces.Services.HttpClients;
using EMS.Application.Common.Models;
using MediatR;
using Microsoft.Extensions.Logging;

namespace EMS.Application.Features.Auth.Commands.ForgotPassword
{
    public record ForgotPasswordCommand(
        string Email) : IRequest<Result>;

    public class ForgotPasswordCommandHandler : IRequestHandler<ForgotPasswordCommand, Result>
    {
        private readonly ILogger<ForgotPasswordCommandHandler> _logger;
        private readonly IIdentityService _identityService;
        private readonly IDispatcherService _dispatcherService;

        public ForgotPasswordCommandHandler(
            ILogger<ForgotPasswordCommandHandler> logger,
            IIdentityService identityService,
            IDispatcherService dispatcherService)
        {
            _logger = logger;
            _identityService = identityService;
            _dispatcherService = dispatcherService;
        }
        public async Task<Result> Handle(ForgotPasswordCommand request, CancellationToken cancellationToken)
        {
            var email = request.Email;

            try
            {
                var (result, token) = await _identityService.GeneratePasswordResetEmailAsync(email, cancellationToken);
                if (!result.Succeeded)
                {
                    return Result.Success(result.Errors?.FirstOrDefault());
                }

                var pwResetEmail = result.Value!;

                await _dispatcherService.SendEmailAsync(pwResetEmail);

                _logger.LogInformation("Password reset email sent to {Email}", email);

                return Result.Success();
            }
            catch (Exception ex)
            {
                _logger.LogError("An error occurred while handling forgot password request: {Msg}",
                    ex.Message);

                throw;
            }
        }
    }
}
