using EMS.Application.Common.Models;
using EMS.Core.Entities;
using System.Security.Claims;

namespace EMS.Application.Common.Interfaces.Services
{
    public interface ITokenService
    {
        Task<TokenResponse> GenerateTokensAsync(string userId, CancellationToken cancellationToken = default);
        Task<TokenResponse> RefreshTokenAsync(string accessToken, string refreshToken, CancellationToken cancellationToken = default);
        Task RevokeTokenAsync(string userId, CancellationToken cancellationToken = default);
        bool ValidateAccessToken(string accessToken);
    }
}
