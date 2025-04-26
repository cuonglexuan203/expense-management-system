using EMS.Application.Common.Interfaces.Services;
using EMS.Application.Features.DeviceTokens.Services;
using EMS.Core.Enums;
using MediatR;
using Microsoft.Extensions.Logging;

namespace EMS.Application.Features.DeviceTokens.Commands.AddDeviceToken
{
    public record AddDeviceTokenCommand(string Token, Platform? Platform) : IRequest<Unit>;

    public class AddDeviceTokenCommandHandler : IRequestHandler<AddDeviceTokenCommand, Unit>
    {
        private readonly ILogger<AddDeviceTokenCommandHandler> _logger;
        private readonly ICurrentUserService _user;
        private readonly IDeviceTokenService _dtService;

        public AddDeviceTokenCommandHandler(
            ILogger<AddDeviceTokenCommandHandler> logger,
            ICurrentUserService user,
            IDeviceTokenService dtService)
        {
            _logger = logger;
            _user = user;
            _dtService = dtService;
        }
        public async Task<Unit> Handle(AddDeviceTokenCommand request, CancellationToken cancellationToken)
        {
            var userId = _user.Id!;

            await _dtService.AddDeviceTokenAsync(userId, request.Token, request.Platform);

            return Unit.Value;
        }
    }
}
