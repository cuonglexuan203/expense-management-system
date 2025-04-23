using EMS.Application.Features.DeviceTokens.Dtos;
using EMS.Core.Enums;

namespace EMS.Application.Features.DeviceTokens.Services
{
    public interface IDeviceTokenService
    {
        Task<DeviceTokenDto> AddDeviceTokenAsync(string userId, string token, Platform? platform = null);
        Task<List<DeviceTokenDto>> GetDeviceTokensAsync(string userId, CancellationToken cancellationToken = default);
        Task<bool> RemoveDeviceTokenAsync(string userId, string token, CancellationToken cancellationToken = default);
    }
}
