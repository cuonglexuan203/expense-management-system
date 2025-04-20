using EMS.Application.Common.Interfaces.DbContext;
using EMS.Application.Common.Interfaces.Services;
using EMS.Core.Entities;
using EMS.Core.Enums;
using MediatR;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Logging;

namespace EMS.Application.Features.DeviceTokens.Commands.AddDeviceToken
{
    public record AddDeviceTokenCommand(string Token, Platform? Platform) : IRequest<Unit>;

    public class AddDeviceTokenCommandHandler : IRequestHandler<AddDeviceTokenCommand, Unit>
    {
        private readonly ILogger<AddDeviceTokenCommandHandler> _logger;
        private readonly ICurrentUserService _user;
        private readonly IApplicationDbContext _context;

        public AddDeviceTokenCommandHandler(
            ILogger<AddDeviceTokenCommandHandler> logger,
            ICurrentUserService user,
            IApplicationDbContext context)
        {
            _logger = logger;
            _user = user;
            _context = context;
        }
        public async Task<Unit> Handle(AddDeviceTokenCommand request, CancellationToken cancellationToken)
        {
            var userId = _user.Id!;

            try
            {
                var token = request.Token;
                var platform = request.Platform;

                if (await _context.DeviceTokens
                    .AnyAsync(e => !e.IsDeleted
                        && e.IsActive
                        && e.UserId == userId
                        && e.Token == token))
                {
                    return Unit.Value;
                }

                _logger.LogInformation("New login detected for user {UserId} on a new device {Platform} at {Time}",
                    userId,
                    platform,
                    DateTimeOffset.UtcNow);

                var deviceToken = DeviceToken.Create(userId, token, platform);

                _context.DeviceTokens.Add(deviceToken);

                await _context.SaveChangesAsync();

                return Unit.Value;
            }
            catch (Exception ex)
            {
                _logger.LogError("An error occurred while adding the device token for user ID {UserId}: {Msg}",
                    userId,
                    ex.Message);

                throw;
            }
        }
    }
}
