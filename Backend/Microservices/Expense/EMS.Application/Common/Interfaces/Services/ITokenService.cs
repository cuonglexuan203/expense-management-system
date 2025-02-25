using EMS.Core.Entities;
using System.Security.Claims;

namespace EMS.Application.Common.Interfaces.Services
{
    public interface ITokenService
    {
        string GenerateAccessToken(IUser<string> user);
        string GenerateRefreshToken();
        ClaimsPrincipal GetClaimsPrincipalFromExpiredToken(string token);
    }
}
