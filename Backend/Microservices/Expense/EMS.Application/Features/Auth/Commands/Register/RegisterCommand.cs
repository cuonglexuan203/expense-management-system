using EMS.Application.Common.Exceptions;
using EMS.Application.Common.Interfaces.Services;
using MediatR;
using Microsoft.Extensions.Logging;

namespace EMS.Application.Features.Auth.Commands.Register
{
    public class RegisterCommand : IRequest<RegisterDto>
    {
        public string Email { get; set; } = default!;
        public string Password { get; set; } = default!;
    }

    public class RegisterCommandHandler : IRequestHandler<RegisterCommand, RegisterDto>
    {
        private readonly ILogger<RegisterCommandHandler> _logger;
        private readonly IIdentityService _identityService;

        public RegisterCommandHandler(ILogger<RegisterCommandHandler> logger, IIdentityService identityService)
        {
            _logger = logger;
            _identityService = identityService;
        }

        public async Task<RegisterDto> Handle(RegisterCommand request, CancellationToken cancellationToken)
        {
            var (result, userId) = await _identityService.CreateUserAsync(request.Email, request.Password);

            if (!result.Succeeded)
            {
                throw new BadRequestException(string.Join(", ", result.Errors));
            }

            _logger.LogInformation("User {0} registered", request.Email);

            return new(userId);
        }
    }
}
