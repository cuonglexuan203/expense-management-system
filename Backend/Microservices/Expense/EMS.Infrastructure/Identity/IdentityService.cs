using EMS.Application.Common.Interfaces.Services;
using EMS.Application.Common.Models;
using EMS.Infrastructure.Common.Options;
using EMS.Infrastructure.Identity.Models;
using Microsoft.AspNetCore.Identity;
using Microsoft.Extensions.Options;
using Microsoft.AspNetCore.Authorization;
using EMS.Application.Common.DTOs.Dispatcher;
using Microsoft.Extensions.Logging;
using System.Web;

namespace EMS.Infrastructure.Identity
{
    public class IdentityService : IIdentityService
    {
        private readonly ILogger<IdentityService> _logger;
        private readonly UserManager<ApplicationUser> _userManager;
        private readonly RoleManager<ApplicationRole> _roleManager;
        private readonly IUserClaimsPrincipalFactory<ApplicationUser> _userClaimsPrincipalFactory;
        private readonly IAuthorizationService _authorizationService;
        private readonly IDistributedCacheService _cacheService;
        private readonly AppSettingOptions _appSettings;

        public IdentityService(
            ILogger<IdentityService> logger,
            UserManager<ApplicationUser> userManager,
            ITokenService tokenService,
            IOptions<JwtSettings> jwtSettings,
            RoleManager<ApplicationRole> roleManager,
            IUserClaimsPrincipalFactory<ApplicationUser> userClaimsPrincipalFactory,
            IAuthorizationService authorizationService,
            IDistributedCacheService cacheService,
            IOptions<AppSettingOptions> appSettings)
        {
            _logger = logger;
            _userManager = userManager;
            _roleManager = roleManager;
            _userClaimsPrincipalFactory = userClaimsPrincipalFactory;
            _authorizationService = authorizationService;
            _cacheService = cacheService;
            _appSettings = appSettings.Value;
        }

        public async Task<(Result Result, string UserId)> CreateUserAsync(string userName, string password, CancellationToken cancellationToken = default)
        {
            var user = new ApplicationUser
            {
                UserName = userName,
                Email = userName,
                FullName = string.Empty,
                Avatar = string.Empty,
            };

            var result = await _userManager.CreateAsync(user, password);

            return (result.ToApplicationResult(), user.Id);
        }

        public async Task<Result> DeleteUserAsync(string userId, CancellationToken cancellationToken = default)
        {
            var user = await _userManager.FindByIdAsync(userId);

            if (user == null)
            {
                return Result.Failure(["User not found"]);
            }

            var result = await _userManager.DeleteAsync(user);

            return result.ToApplicationResult();
        }

        public async Task<bool> IsInRoleAsync(string userId, string role, CancellationToken cancellationToken = default)
        {
            var user = await _userManager.FindByIdAsync(userId);

            if (user == null)
            {
                return false;
            }

            return await _userManager.IsInRoleAsync(user, role);
        }

        public async Task<Result> AddToRoleAsync(string userId, string role, CancellationToken cancellationToken = default)
        {
            var user = await _userManager.FindByIdAsync(userId);

            if (user == null)
            {
                return Result.Failure(["User not found"]);
            }

            if (!await _roleManager.RoleExistsAsync(role))
            {
                var roleResult = await _roleManager.CreateAsync(new ApplicationRole(role));
                if (!roleResult.Succeeded)
                {
                    return roleResult.ToApplicationResult();
                }
            }

            var result = await _userManager.AddToRoleAsync(user, role);

            return result.ToApplicationResult();
        }

        public async Task<Result> RemoveFromRoleAsync(string userId, string role, CancellationToken cancellationToken = default)
        {
            var user = await _userManager.FindByIdAsync(userId);

            if (user == null)
            {
                return Result.Failure(["User not found"]);
            }

            var result = await _userManager.RemoveFromRoleAsync(user, role);

            return result.ToApplicationResult();
        }

        public async Task<bool> AuthorizeAsync(string userId, string policyName, CancellationToken cancellationToken = default)
        {

            var user = await _userManager.FindByIdAsync(userId);

            if (user == null)
            {
                return false;
            }

            var principal = await _userClaimsPrincipalFactory.CreateAsync(user);
            var result = await _authorizationService.AuthorizeAsync(principal, policyName);

            return result.Succeeded;
        }
        public async Task<Result> UpdateUserAsync(string userId, string userName, CancellationToken cancellationToken = default)
        {
            var user = await _userManager.FindByIdAsync(userId);

            if (user == null)
            {
                return Result.Failure(["User not found"]);
            }

            user.UserName = userName;
            user.Email = userName;

            var result = await _userManager.UpdateAsync(user);

            return result.ToApplicationResult();
        }

        public async Task<Result> ChangePasswordAsync(string userId, string currentPassword, string newPassword, CancellationToken cancellationToken = default)
        {
            var user = await _userManager.FindByIdAsync(userId);

            if (user == null)
            {
                return Result.Failure(["User not found"]);
            }

            var result = await _userManager.ChangePasswordAsync(user, currentPassword, newPassword);

            return result.ToApplicationResult();
        }


        public async Task<(Result result, string? userId)> ValidateUserAsync(string userName, string password, CancellationToken cancellationToken = default)
        {
            var user = await _userManager.FindByNameAsync(userName);

            if (user == null)
            {
                return (Result.Failure(["User not found"]), null);
            }

            var result = await _userManager.CheckPasswordAsync(user, password);

            return result ?
                (Result.Success(), user.Id) :
                (Result.Failure(["Invalid password"]), null);
        }

        public async Task<string?> GetUserNameAsync(string userId, CancellationToken cancellationToken = default)
        {
            var user = await _userManager.FindByIdAsync(userId);

            return user?.UserName;
        }

        public async Task<Result> CreateRoleAsync(string roleName, CancellationToken cancellationToken = default)
        {
            var roleResult = await _roleManager.CreateAsync(new ApplicationRole(roleName));

            return roleResult.ToApplicationResult();
        }

        public async Task<(Result<EmailDispatchRequest> Result, string? PasswordResetToken)> GeneratePasswordResetEmailAsync(
            string email,
            CancellationToken cancellationToken = default)
        {
            var user = await _userManager.FindByEmailAsync(email);
            if (user == null)
            {
                _logger.LogWarning("Password reset requested for non-existent email: {Email}", email);

                return (Result.Failure<EmailDispatchRequest>(["If an account with this email exists, a password reset email has been sent."]), null);
            }

            var rateLimitKey = $"pw_reset_request_limit:{email}";
            if (await _cacheService.KeyExistsAsync(rateLimitKey))
            {
                _logger.LogWarning("Password reset hit the rate limit for: {Email}", email);

                return (Result.Failure<EmailDispatchRequest>(["Password reset hit the rate limit, please try again later."]), null);
            }

            await _cacheService.SetAsync<string>(rateLimitKey, "1", TimeSpan.FromSeconds(30));

            var token = await _userManager.GeneratePasswordResetTokenAsync(user);
            var encodedToken = HttpUtility.UrlEncode(token);

            var feResetUrl = _appSettings.MobileResetPasswordUrl;
            var callbackUrl = $"{feResetUrl}?email={HttpUtility.UrlEncode(email)}&token={encodedToken}";

            var pwResetEmail = new EmailDispatchRequest
            {
                To = email,
                Subject = "Reset Your Password - EMS",
                HtmlBody = $"<p>Please reset your password by clicking the link below:</p>" +
                           $"<p><a href='{callbackUrl}'>Reset Password</a></p>" +
                           $"<p>This link is valid for 10 minutes.</p>" +
                           $"<p>If you did not request a password reset, please ignore this email.</p>"
            };

            return (Result.Success(pwResetEmail), token);
        }

        public async Task<Result> ResetPasswordAsync(string email, string token, string newPassword, CancellationToken cancellationToken = default)
        {
            var user = await _userManager.FindByEmailAsync(email);
            if (user == null)
            {
                _logger.LogWarning("Password reset attempt for non-existent email: {Email}", email);

                return Result.Failure(["Invalid password reset request"]);
            }

            var result = await _userManager.ResetPasswordAsync(user, token, newPassword);

            if (result.Succeeded)
            {
                _logger.LogInformation("Password successfully reset for user {Email}", email);

                await _cacheService.RemoveAsync($"pw_reset_request_limit:{email}");

                return Result.Success("Password has been reset successfully.");
            }

            _logger.LogWarning("Password reset failed for user {Email}. Errors: {Errors}",
                email,
                string.Join(", ", result.Errors.Select(e => e.Description)));

            return Result.Failure(result.Errors.Select(e => e.Description));
        }
    }
}
