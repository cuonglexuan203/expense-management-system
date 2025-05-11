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
using AutoMapper;
using EMS.Application.Features.Profiles.Dtos;

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
        private readonly IMapper _mapper;
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
            IOptions<AppSettingOptions> appSettings,
            IMapper mapper)
        {
            _logger = logger;
            _userManager = userManager;
            _roleManager = roleManager;
            _userClaimsPrincipalFactory = userClaimsPrincipalFactory;
            _authorizationService = authorizationService;
            _cacheService = cacheService;
            _mapper = mapper;
            _appSettings = appSettings.Value;
        }

        public async Task<(Result Result, string UserId)> CreateUserAsync(
            string userName,
            string password,
            UserDto userDto,
            CancellationToken cancellationToken = default)
        {
            var user = new ApplicationUser
            {
                UserName = userName,
                Email = userDto.Email,
                FullName = userDto.FullName ?? string.Empty,
                Avatar = userDto.Avatar ?? string.Empty,
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
        public async Task<Result> UpdateUserAsync(string userId, UserDto userDto, CancellationToken cancellationToken = default)
        {
            var user = await _userManager.FindByIdAsync(userId);

            if (user == null)
            {
                return Result.Failure(["User not found"]);
            }

            // Allows: email, full name, avatar.
            if (!string.IsNullOrEmpty(userDto.Email))
            {
                user.Email = userDto.Email;
            }

            if (!string.IsNullOrEmpty(userDto.FullName))
            {
                user.FullName = userDto.FullName;
            }

            if (!string.IsNullOrEmpty(userDto.Avatar))
            {
                user.Avatar = userDto.Avatar;
            }

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
                HtmlBody = $@"
<!DOCTYPE html>
<html lang=""en"">
<head>
    <meta charset=""UTF-8"">
    <meta name=""viewport"" content=""width=device-width, initial-scale=1.0"">
    <title>Reset Your Password</title>
    <style>
        /* Using direct color values instead of CSS variables */
        * {{
            box-sizing: border-box;
            margin: 0;
            padding: 0;
        }}
        
        body {{
            font-family: 'Inter', -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, Helvetica, Arial, sans-serif;
            line-height: 1.6;
            color: #1F2937;
            background-color: #F9FAFB;
            -webkit-font-smoothing: antialiased;
            -moz-osx-font-smoothing: grayscale;
        }}
        
        .email-wrapper {{
            width: 100%;
            margin: 0 auto;
            max-width: 600px;
        }}
        
        .email-container {{
            margin: 24px auto;
            background-color: #FFFFFF;
            border-radius: 16px;
            overflow: hidden;
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.05);
        }}
        
        .email-header {{
            background: linear-gradient(135deg, #4F46E5, #06B6D4);
            padding: 32px 24px;
            text-align: center;
            color: #FFFFFF;
        }}
        
        .logo {{
            margin-bottom: 16px;
        }}
        
        .logo-img {{
            width: 48px;
            height: 48px;
        }}
        
        .header-title {{
            font-size: 24px;
            font-weight: 700;
            margin-bottom: 8px;
            letter-spacing: -0.025em;
        }}
        
        .header-subtitle {{
            font-size: 16px;
            font-weight: 400;
            opacity: 0.9;
        }}
        
        .email-body {{
            padding: 40px 32px;
            background-color: #FFFFFF;
        }}
        
        .greeting {{
            font-size: 18px;
            font-weight: 600;
            margin-bottom: 16px;
            color: #1F2937;
        }}
        
        .message {{
            font-size: 16px;
            margin-bottom: 24px;
            color: #1F2937;
        }}
        
        .button-container {{
            text-align: center;
            margin: 32px 0;
        }}
        
        .reset-button {{
            display: inline-block;
            background-color: #4F46E5;
            color: #FFFFFF !important;
            font-weight: 600;
            font-size: 16px;
            text-decoration: none;
            padding: 12px 32px;
            border-radius: 8px;
            box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
            transition: background-color 0.2s ease;
        }}
        
        .reset-button:hover {{
            background-color: #4338CA;
        }}
        
        .alt-link {{
            margin-top: 16px;
            padding: 16px;
            background-color: #EEF2FF;
            border-radius: 8px;
            word-break: break-all;
            font-size: 14px;
            color: #6B7280;
        }}
        
        .expiry-notice {{
            display: flex;
            align-items: center;
            margin: 24px 0;
            padding: 16px;
            background-color: #FEF2F2;
            border-left: 4px solid #EF4444;
            border-radius: 4px;
        }}
        
        .expiry-notice svg {{
            margin-right: 12px;
            flex-shrink: 0;
        }}
        
        .expiry-text {{
            font-weight: 500;
            color: #B91C1C;
        }}
        
        .security-notice {{
            margin-top: 32px;
            padding: 16px;
            background-color: #F3F4F6;
            border-radius: 8px;
        }}
        
        .security-notice p {{
            font-size: 14px;
            color: #6B7280;
        }}
        
        .signature {{
            margin-top: 32px;
        }}
        
        .team-name {{
            font-weight: 600;
            color: #1F2937;
        }}
        
        .email-footer {{
            padding: 24px;
            background-color: #F3F4F6;
            text-align: center;
            border-top: 1px solid #E5E7EB;
        }}
        
        .footer-text {{
            font-size: 14px;
            color: #6B7280;
            margin-bottom: 12px;
        }}
        
        .social-links {{
            justify-content: center !important;
            display: flex;
            margin: 16px 0;
        }}
        
        .social-link {{
            display: inline-flex;
            align-items: center;
            justify-content: center;
            width: 32px;
            height: 32px;
            border-radius: 50%;
            background-color: #4F46E5;
            margin: 0 8px;
            color: #FFFFFF !important;
            text-decoration: none;
        }}
        
        .footer-links {{
            margin-top: 16px;
        }}
        
        .footer-link {{
            color: #6B7280;
            text-decoration: underline;
            margin: 0 8px;
            font-size: 12px;
        }}
        
        .copyright {{
            margin-top: 16px;
            font-size: 12px;
            color: #6B7280;
        }}
        
        /* Responsive adjustments */
        @media screen and (max-width: 600px) {{
            .email-wrapper {{
                width: 100%;
                padding: 0 16px;
            }}
            
            .email-header, .email-body, .email-footer {{
                padding: 24px 16px;
            }}
            
            .header-title {{
                font-size: 22px;
            }}
        }}
    </style>
</head>
<body>
    <div class=""email-wrapper"">
        <div class=""email-container"">
            <!-- Header -->
            <div class=""email-header"">
                <div class=""logo"">
                    <svg class=""logo-img"" viewBox=""0 0 24 24"" fill=""none"" xmlns=""http://www.w3.org/2000/svg"">
                        <path d=""M12 2L2 7L12 12L22 7L12 2Z"" stroke=""white"" stroke-width=""2"" stroke-linecap=""round"" stroke-linejoin=""round""/>
                        <path d=""M2 17L12 22L22 17"" stroke=""white"" stroke-width=""2"" stroke-linecap=""round"" stroke-linejoin=""round""/>
                        <path d=""M2 12L12 17L22 12"" stroke=""white"" stroke-width=""2"" stroke-linecap=""round"" stroke-linejoin=""round""/>
                    </svg>
                </div>
                <h1 class=""header-title"">Reset Your Password</h1>
                <p class=""header-subtitle"">Expense Management System</p>
            </div>
            
            <!-- Body -->
            <div class=""email-body"">
                <p class=""greeting"">Hello there,</p>
                <p class=""message"">We received a password reset request for your EMS account. To create a new password and regain access to your account, click the button below:</p>
                
                <div class=""button-container"">
                    <a href=""{callbackUrl}"" class=""reset-button"">Reset Password</a>
                </div>
                
                <p class=""message"">If the button above doesn't work, you can copy and paste this URL into your browser:</p>
                <div class=""alt-link"">
                    {callbackUrl}
                </div>
                
                <div class=""expiry-notice"">
                    <svg width=""20"" height=""20"" viewBox=""0 0 20 20"" fill=""none"" xmlns=""http://www.w3.org/2000/svg"">
                        <path d=""M10 18.3333C14.6024 18.3333 18.3334 14.6024 18.3334 10C18.3334 5.39763 14.6024 1.66667 10 1.66667C5.39765 1.66667 1.66669 5.39763 1.66669 10C1.66669 14.6024 5.39765 18.3333 10 18.3333Z"" stroke=""#B91C1C"" stroke-width=""1.5"" stroke-linecap=""round"" stroke-linejoin=""round""/>
                        <path d=""M10 6.66667V10"" stroke=""#B91C1C"" stroke-width=""2"" stroke-linecap=""round"" stroke-linejoin=""round""/>
                        <path d=""M10 13.3333H10.0083"" stroke=""#B91C1C"" stroke-width=""2"" stroke-linecap=""round"" stroke-linejoin=""round""/>
                    </svg>
                    <span class=""expiry-text"">This link is only valid for 5 minutes for security reasons.</span>
                </div>
                
                <div class=""security-notice"">
                    <p>If you didn't request a password reset, please disregard this email. No changes will be made to your account unless you access the link above.</p>
                </div>
                
                <div class=""signature"">
                    <p>Thank you,</p>
                    <p class=""team-name"">The EMS Team</p>
                </div>
            </div>
            
            <!-- Footer -->
            <div class=""email-footer"">
                <p class=""footer-text"">© {DateTime.UtcNow.Year} Expense Management System. All rights reserved.</p>
                <!--
                <div class=""social-links"">
                    <a href=""#"" class=""social-link"">
                        <svg width=""16"" height=""16"" viewBox=""0 0 24 24"" fill=""white"" xmlns=""http://www.w3.org/2000/svg"">
                            <path d=""M18 2H15C13.6739 2 12.4021 2.52678 11.4645 3.46447C10.5268 4.40215 10 5.67392 10 7V10H7V14H10V22H14V14H17L18 10H14V7C14 6.73478 14.1054 6.48043 14.2929 6.29289C14.4804 6.10536 14.7348 6 15 6H18V2Z"" stroke=""white"" stroke-width=""2"" stroke-linecap=""round"" stroke-linejoin=""round""/>
                        </svg>
                    </a>
                    <a href=""#"" class=""social-link"">
                        <svg width=""16"" height=""16"" viewBox=""0 0 24 24"" fill=""white"" xmlns=""http://www.w3.org/2000/svg"">
                            <path d=""M23 3.00005C22.0424 3.67552 20.9821 4.19216 19.86 4.53005C19.2577 3.83756 18.4573 3.34674 17.567 3.12397C16.6767 2.90121 15.7395 2.95724 14.8821 3.2845C14.0247 3.61176 13.2884 4.19445 12.773 4.95376C12.2575 5.71308 11.9877 6.61238 12 7.53005V8.53005C10.2426 8.57561 8.50127 8.18586 6.93101 7.39549C5.36074 6.60513 4.01032 5.43868 3 4.00005C3 4.00005 -1 13 8 17C5.94053 18.398 3.48716 19.099 1 19C10 24 21 19 21 7.50005C20.9991 7.2215 20.9723 6.94364 20.92 6.67005C21.9406 5.66354 22.6608 4.39276 23 3.00005Z"" stroke=""white"" stroke-width=""2"" stroke-linecap=""round"" stroke-linejoin=""round""/>
                        </svg>
                    </a>
                    <a href=""#"" class=""social-link"">
                        <svg width=""16"" height=""16"" viewBox=""0 0 24 24"" fill=""white"" xmlns=""http://www.w3.org/2000/svg"">
                            <path d=""M16 8C17.5913 8 19.1174 8.63214 20.2426 9.75736C21.3679 10.8826 22 12.4087 22 14V21H18V14C18 13.4696 17.7893 12.9609 17.4142 12.5858C17.0391 12.2107 16.5304 12 16 12C15.4696 12 14.9609 12.2107 14.5858 12.5858C14.2107 12.9609 14 13.4696 14 14V21H10V14C10 12.4087 10.6321 10.8826 11.7574 9.75736C12.8826 8.63214 14.4087 8 16 8Z"" stroke=""white"" stroke-width=""2"" stroke-linecap=""round"" stroke-linejoin=""round""/>
                            <path d=""M6 9H2V21H6V9Z"" stroke=""white"" stroke-width=""2"" stroke-linecap=""round"" stroke-linejoin=""round""/>
                            <path d=""M4 6C5.10457 6 6 5.10457 6 4C6 2.89543 5.10457 2 4 2C2.89543 2 2 2.89543 2 4C2 5.10457 2.89543 6 4 6Z"" stroke=""white"" stroke-width=""2"" stroke-linecap=""round"" stroke-linejoin=""round""/>
                        </svg>
                    </a>
                </div>
                -->
                
                <div class=""footer-links"">
                    <a href=""#"" class=""footer-link"">Privacy Policy</a>
                    <a href=""#"" class=""footer-link"">Terms of Service</a>
                    <a href=""#"" class=""footer-link"">Contact Support</a>
                </div>
                <!--
                <p class=""copyright"">© {DateTime.UtcNow.Year} Expense Management System. All rights reserved.</p>
                -->
            </div>
        </div>
    </div>
</body>
</html>
"
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

        public async Task<UserDto?> GetUserAsync(string userId, CancellationToken cancellationToken = default)
        {
            var user = await _userManager.FindByIdAsync(userId);

            return _mapper.Map<UserDto>(user);
        }
    }
}
