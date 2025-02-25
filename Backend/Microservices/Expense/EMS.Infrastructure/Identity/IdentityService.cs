using EMS.Application.Common.Interfaces.DbContext;
using EMS.Application.Common.Interfaces.Services;
using EMS.Application.Common.Models;
using EMS.Infrastructure.Common.Options;
using EMS.Infrastructure.Identity.Models;
using Microsoft.AspNetCore.Identity;
using Microsoft.Extensions.Options;
using Microsoft.IdentityModel.Tokens;
using System.IdentityModel.Tokens.Jwt;
using System.Security.Claims;

namespace EMS.Infrastructure.Identity
{
    public class IdentityService : IIdentityService
    {
        private readonly UserManager<ApplicationUser> _userManager;
        private readonly IApplicationDbContext _context;
        private readonly ITokenService _tokenService;
        private readonly JwtSettings _jwtSettings;

        public IdentityService(UserManager<ApplicationUser> userManager, IApplicationDbContext context,
            ITokenService tokenService, IOptions<JwtSettings> jwtSettings)
        {
            _userManager = userManager;
            _context = context;
            _tokenService = tokenService;
            _jwtSettings = jwtSettings.Value;
        }
        public Task<bool> AuthorizeAsync(string userId, string policyName)
        {
            throw new NotImplementedException();
        }

        public Task<Result> ConfirmEmailAsync(string userId, string token)
        {
            throw new NotImplementedException();
        }

        public Task<(Result result, string userId)> CreateUserAsync(string userName, string password)
        {
            throw new NotImplementedException();
        }

        public Task<Result> DeleteUserAsync(string userId)
        {
            throw new NotImplementedException();
        }

        public Task<string> GenerateEmailConfirmationTokenAsync(string email)
        {
            throw new NotImplementedException();
        }

        public Task<string?> GetUserNameAsync(string userId)
        {
            throw new NotImplementedException();
        }

        public Task<bool> IsInRoleAsync(string userId, string roleName)
        {
            throw new NotImplementedException();
        }

        //

        public async Task<TokenResponse> LoginAsync(string email, string password)
        {
            var user = await _userManager.FindByEmailAsync(email);

            if (user == null || !await _userManager.CheckPasswordAsync(user, password))
                throw new UnauthorizedAccessException("Invalid credentials");

            return await GenerateTokensAsync(user);
        }

        public Task LogoutAsync(string accessToken)
        {
            throw new NotImplementedException();
        }

        public async Task<TokenResponse> RefreshTokenAsync(string accessToken, string refreshToken)
        {
            var principal = _tokenService.GetClaimsPrincipalFromExpiredToken(accessToken);
            var userId = principal.FindFirstValue(JwtRegisteredClaimNames.Sub);

            if (userId == null)
                throw new SecurityTokenException("Invalid token");

            var user = await _userManager.FindByIdAsync(userId);

            if (user == null)
                throw new SecurityTokenException("Invalid token");

            var storedRefreshToken = _context.RefreshTokens.FirstOrDefault(e => e.Token == refreshToken);

            if (storedRefreshToken == null || storedRefreshToken.UserId != userId || !storedRefreshToken.IsActive)
                throw new SecurityTokenException("Invalid token");

            storedRefreshToken.Expires = DateTime.UtcNow;
            await _context.SaveChangesAsync();

            return await GenerateTokensAsync(user);

        }

        public Task<Result> RegisterAsync(string email, string password)
        {
            throw new NotImplementedException();
        }

        public Task RequestPasswordResetAsync(string email)
        {
            throw new NotImplementedException();
        }

        public Task<Result> ResetPasswordAsync(string email, string token, string newPassword)
        {
            throw new NotImplementedException();
        }

        public Task RevokeRefreshTokensForUser(string userId)
        {
            throw new NotImplementedException();
        }

        private async Task<TokenResponse> GenerateTokensAsync(ApplicationUser user)
        {
            var accessToken = _tokenService.GenerateAccessToken(user);
            var refreshToken = _tokenService.GenerateRefreshToken();

            _context.RefreshTokens.Add(new Core.Entities.RefreshToken(user.Id, refreshToken, DateTime.UtcNow.AddDays(_jwtSettings.RefreshTokenExpirationInDays)));
            await _context.SaveChangesAsync();

            return new(accessToken, refreshToken, DateTime.UtcNow.AddMinutes(_jwtSettings.AccessTokenExpirationInMinutes));
        }
    }
}
