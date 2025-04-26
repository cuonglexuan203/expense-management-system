using AutoMapper;
using EMS.Application.Common.Exceptions;
using EMS.Application.Common.Interfaces.DbContext;
using EMS.Application.Features.DeviceTokens.Dtos;
using EMS.Application.Features.DeviceTokens.Services;
using EMS.Core.Entities;
using EMS.Core.Enums;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Logging;

namespace EMS.Infrastructure.Services
{
    public class DeviceTokenService : IDeviceTokenService
    {
        private readonly ILogger<DeviceTokenService> _logger;
        private readonly IApplicationDbContext _context;
        private readonly IMapper _mapper;

        public DeviceTokenService(
            ILogger<DeviceTokenService> logger,
            IApplicationDbContext context,
            IMapper mapper)
        {
            _logger = logger;
            _context = context;
            _mapper = mapper;
        }
        public async Task<DeviceTokenDto> AddDeviceTokenAsync(string userId, string token, Platform? platform = null)
        {
            try
            {
                var deviceToken = await _context.DeviceTokens
                    .FirstOrDefaultAsync(e => !e.IsDeleted
                        && e.IsActive
                        && e.UserId == userId
                        && e.Token == token);

                if (deviceToken != null)
                {
                    deviceToken.LastUsedAt = DateTimeOffset.UtcNow;
                    await _context.SaveChangesAsync();

                    return _mapper.Map<DeviceTokenDto>(deviceToken);
                }

                _logger.LogInformation("New login detected for user {UserId} on a new device {Platform} at {Time}",
                    userId,
                    platform,
                    DateTimeOffset.UtcNow);

                var newDeviceToken = DeviceToken.Create(userId, token, platform);

                _context.DeviceTokens.Add(newDeviceToken);

                await _context.SaveChangesAsync();

                return _mapper.Map<DeviceTokenDto>(deviceToken);
            }
            catch (Exception ex)
            {
                _logger.LogError("An error occurred while adding the device token for user ID {UserId}: {Msg}",
                    userId,
                    ex.Message);

                throw;
            }
        }

        public async Task<List<DeviceTokenDto>> GetDeviceTokensAsync(string userId, CancellationToken cancellationToken)
        {
            var deviceTokens = await _context.DeviceTokens
                .AsNoTracking()
                .Where(e => !e.IsDeleted && e.UserId == userId)
                .ToListAsync();

            return _mapper.Map<List<DeviceTokenDto>>(deviceTokens);
        }

        public async Task<bool> RemoveDeviceTokenAsync(string userId, string token, CancellationToken cancellationToken)
        {
            var deviceToken = await _context.DeviceTokens
                .FirstOrDefaultAsync(e => !e.IsDeleted
                    && e.UserId == userId
                    && e.Token == token) ?? throw new NotFoundException("Token not found.");

            _context.DeviceTokens.Remove(deviceToken);
            await _context.SaveChangesAsync(cancellationToken);

            return true;
        }
    }
}
