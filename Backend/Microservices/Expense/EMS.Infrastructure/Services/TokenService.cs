using EMS.Application.Common.Interfaces.Services;
using EMS.Application.Common.Models;
using EMS.Core.Entities;
using EMS.Infrastructure.Common.Options;
using EMS.Infrastructure.Identity.Models;
using EMS.Infrastructure.Persistence.DbContext;
using Microsoft.AspNetCore.Identity;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Options;
using Microsoft.IdentityModel.Tokens;
using System.IdentityModel.Tokens.Jwt;
using System.Security.Claims;
using System.Security.Cryptography;
using System.Text;

namespace EMS.Infrastructure.Services
{
    public class TokenService : ITokenService
    {
        private readonly JwtSettings _settings;
        private readonly ApplicationDbContext _context;
        private readonly UserManager<ApplicationUser> _userManager;

        public TokenService(IOptions<JwtSettings> settings, ApplicationDbContext context, UserManager<ApplicationUser> userManager)
        {
            _settings = settings.Value;
            _context = context;
            _userManager = userManager;
        }

        public async Task<TokenResponse> GenerateTokensAsync(string userId, CancellationToken cancellationToken = default)
        {
            var user = await _userManager.FindByIdAsync(userId);

            if (user == null)
            {
                throw new UnauthorizedAccessException("User not found");
            }

            var userRoles = await _userManager.GetRolesAsync(user);

            var accessToken = GenerateAccessToken(user, userRoles);

            var refreshToken = GenerateRefreshToken();

            user.RefreshTokens ??= new List<RefreshToken>();

            var oldRefreshTokens = await _context.RefreshTokens
                .Where(e => e.UserId == userId && e.RevokeAt == null && e.ExpiresAt > DateTime.UtcNow)
                .ToListAsync(cancellationToken);

            foreach (var token in oldRefreshTokens)
            {
                token.RevokeAt = DateTime.UtcNow;
            }

            var newRefreshToken = new RefreshToken(userId, refreshToken.Token, refreshToken.ExpiresAt);

            _context.RefreshTokens.Add(newRefreshToken);
            await _context.SaveChangesAsync(cancellationToken);

            return new(accessToken.Token, refreshToken.Token, accessToken.ExpiresAt, refreshToken.ExpiresAt);
        }

        public async Task<TokenResponse> RefreshTokenAsync(string accessToken, string refreshToken, CancellationToken cancellationToken = default)
        {
            var principal = GetClaimsPrincipalFromExpiredToken(accessToken);
            if (principal == null)
            {
                throw new SecurityTokenException("Invalid access token");
            }

            var userId = principal.FindFirstValue(ClaimTypes.NameIdentifier);
            if (userId == null)
            {
                throw new SecurityTokenException("Invalid access token");
            }

            var storedRefreshToken = await _context.RefreshTokens
                .SingleOrDefaultAsync(e => e.Token == refreshToken, cancellationToken);
            if (storedRefreshToken == null ||
                storedRefreshToken.UserId != userId ||
                !storedRefreshToken.IsActive)
            {
                throw new SecurityTokenException("Invalid refresh token");
            }

            storedRefreshToken.RevokeAt = DateTime.UtcNow;

            var user = await _userManager.FindByIdAsync(userId);
            if (user == null)
            {
                throw new SecurityTokenException("User not found");
            }

            return await GenerateTokensAsync(userId, cancellationToken);
        }

        public async Task RevokeTokenAsync(string userId, CancellationToken cancellationToken = default)
        {
            var refreshTokens = await _context.RefreshTokens
                .Where(e => e.UserId == userId && e.RevokeAt == null && e.ExpiresAt > DateTime.UtcNow)
                .ToListAsync(cancellationToken);

            foreach (var refreshToken in refreshTokens)
            {
                refreshToken.RevokeAt = DateTime.UtcNow;
            }

            await _context.SaveChangesAsync();
        }

        public bool ValidateAccessToken(string accessToken)
        {
            var tokenValidationParams = GetTokenValidationParameters();
            tokenValidationParams.ValidateLifetime = false;

            var tokenHandler = new JwtSecurityTokenHandler();
            try
            {

                var principal = tokenHandler.ValidateToken(accessToken, tokenValidationParams, out var securityToken);

                if (securityToken is not JwtSecurityToken jwtSecurityToken ||
                    !jwtSecurityToken.Header.Alg.Equals(SecurityAlgorithms.HmacSha256, StringComparison.OrdinalIgnoreCase))
                    throw new SecurityTokenException("Invalid token");

                return principal != null;
            }
            catch
            {
                return false;
            }
        }

        private (string Token, DateTime ExpiresAt) GenerateAccessToken(IUser<string> user, IList<string> roles)
        {
            var claims = new List<Claim>
            {
                new(ClaimTypes.NameIdentifier, user.Id),
                new(ClaimTypes.Name, user.UserName ?? string.Empty),
                new(ClaimTypes.Email, user.Email ?? string.Empty),
                new(JwtRegisteredClaimNames.Jti, Guid.NewGuid().ToString())
            };

            foreach (var role in roles)
            {
                claims.Add(new(ClaimTypes.Role, role));
            }

            var key = new SymmetricSecurityKey(Encoding.UTF8.GetBytes(_settings.SecretKey ?? throw new InvalidOperationException("JWT Secret not configured")));
            var credentials = new SigningCredentials(key, SecurityAlgorithms.HmacSha256);

            var expiresAt = DateTime.UtcNow.AddMinutes(_settings.AccessTokenExpirationInMinutes);

            var tokenDescriptor = new SecurityTokenDescriptor
            {
                Subject = new ClaimsIdentity(claims),
                Expires = expiresAt,
                SigningCredentials = credentials,
                Issuer = _settings.Issuer,
                Audience = _settings.Audience,
            };

            var tokenHandler = new JwtSecurityTokenHandler();
            var token = tokenHandler.CreateToken(tokenDescriptor);
            return (tokenHandler.WriteToken(token), expiresAt);
        }

        private (string Token, DateTime ExpiresAt) GenerateRefreshToken()
        {
            var randomNumber = new byte[64];
            using var rng = RandomNumberGenerator.Create();
            rng.GetBytes(randomNumber);

            var expiresAt = DateTime.UtcNow.AddDays(_settings.RefreshTokenExpirationInDays);

            return (Convert.ToBase64String(randomNumber), expiresAt);
        }

        private ClaimsPrincipal? GetClaimsPrincipalFromExpiredToken(string token)
        {
            var tokenValidationParams = GetTokenValidationParameters();
            tokenValidationParams.ValidateLifetime = false;

            var tokenHandler = new JwtSecurityTokenHandler();
            try
            {

                var principal = tokenHandler.ValidateToken(token, tokenValidationParams, out var securityToken);

                if (securityToken is not JwtSecurityToken jwtSecurityToken ||
                    !jwtSecurityToken.Header.Alg.Equals(SecurityAlgorithms.HmacSha256, StringComparison.OrdinalIgnoreCase))
                    throw new SecurityTokenException("Invalid token");

                return principal;
            }
            catch
            {
                return null;
            }
        }

        private TokenValidationParameters GetTokenValidationParameters()
        {
            return new()
            {
                ValidateIssuer = true,
                ValidateAudience = true,
                ValidateLifetime = true,
                ValidateIssuerSigningKey = true,
                ValidIssuer = _settings.Issuer,
                ValidAudience = _settings.Audience,
                IssuerSigningKey = new SymmetricSecurityKey(Encoding.UTF8.GetBytes(_settings.SecretKey ?? throw new InvalidOperationException("JWT Secret not configured"))),
                ClockSkew = TimeSpan.Zero,
            };
        }
    }
}
