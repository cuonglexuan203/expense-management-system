using EMS.Application.Common.Exceptions;
using EMS.Application.Common.Interfaces.Services;
using EMS.Application.Features.ExtractedTransactions.Services;
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
        private readonly IUserPreferenceService _userPreferenceService;
        private readonly IChatThreadService _chatThreadService;

        public RegisterCommandHandler(
            ILogger<RegisterCommandHandler> logger,
            IIdentityService identityService,
            IUserPreferenceService userPreferenceService,
            IChatThreadService chatThreadService)
        {
            _logger = logger;
            _identityService = identityService;
            _userPreferenceService = userPreferenceService;
            _chatThreadService = chatThreadService;
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

            await _userPreferenceService.CreateDefaultUserPreferencesAsync(userId, cancellationToken);
            //await _chatThreadService.CreateDefaultChatThreadsAsync(userId);

            _logger.LogInformation("User {0} registered", request.Email);
            return new(userId);
        }
    }
}