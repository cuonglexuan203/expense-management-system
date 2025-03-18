using EMS.Application.Common.Exceptions;
using EMS.Application.Common.Interfaces.DbContext;
using EMS.Application.Common.Interfaces.Services;
using EMS.Core.Constants;
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
        private readonly IApplicationDbContext _dbContext;
        private readonly IUserPreferenceService _userPreferenceService;

        public RegisterCommandHandler(
            ILogger<RegisterCommandHandler> logger,
            IIdentityService identityService,
            IApplicationDbContext dbContext,
            IUserPreferenceService userPreferenceService)
        {
            _logger = logger;
            _identityService = identityService;
            _dbContext = dbContext;
            _userPreferenceService = userPreferenceService;
        }

        public async Task<RegisterDto> Handle(RegisterCommand request, CancellationToken cancellationToken)
        {
            var (result, userId) = await _identityService.CreateUserAsync(request.Email, request.Password);

            if (!result.Succeeded)
            {
                throw new BadRequestException(string.Join(", ", result.Errors));
            }

            var roleResult = await _identityService.AddToRoleAsync(userId, Roles.User);

            if (!roleResult.Succeeded)
            {
                _logger.LogError("Failed to add user {0} to role {1}", request.Email, Roles.User);
                throw new Exception(string.Join(", ", roleResult.Errors));
            }

            await _userPreferenceService.CreateUserPreferencesAsync(userId, cancellationToken);

            _logger.LogInformation("User {0} registered", request.Email);
            return new(userId);
        }
    }
}