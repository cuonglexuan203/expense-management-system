using EMS.Application.Common.Exceptions;
using EMS.Application.Common.Interfaces.Services;
using EMS.Application.Features.Auth.Commands.Login;
using MediatR;
using Microsoft.Extensions.Logging;

namespace EMS.Application.Features.Auth.Commands.ExternalLogin
{
    public record ExternalLoginCommand(
        string? ReturnUrl = default,
        string? RemoteError = default) : IRequest<LoginDto>;

    public class ExternalLoginCommandHandler : IRequestHandler<ExternalLoginCommand, LoginDto>
    {
        private readonly ILogger<ExternalLoginCommandHandler> _logger;
        private readonly IIdentityService _identityService;

        public ExternalLoginCommandHandler(
            ILogger<ExternalLoginCommandHandler> logger,
            IIdentityService identityService)
        {
            _logger = logger;
            _identityService = identityService;
        }
        public async Task<LoginDto> Handle(ExternalLoginCommand request, CancellationToken cancellationToken)
        {
            _logger.LogInformation("ExternalLoginCallback received. ReturnUrl: {ReturnUrl}, RemoteError: {RemoteError}",
                request.ReturnUrl,
                request.RemoteError);

            if (!string.IsNullOrEmpty(request.RemoteError))
            {
                _logger.LogError("Error from external provider: {RemoteError}", request.RemoteError);

                throw new BadRequestException($"Error from external provider: {request.RemoteError}");
            }

            var result = await _identityService.ExternalLoginAsync(request.ReturnUrl, cancellationToken);
            if (!result.Succeeded)
            {
                throw new BadRequestException(string.Join(", ", result.Errors!));
            }

            return result.Value!;
        }
    }
}
