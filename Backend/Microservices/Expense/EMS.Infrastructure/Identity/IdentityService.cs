using EMS.Application.Common.Interfaces.DbContext;
using EMS.Application.Common.Interfaces.Services;
using EMS.Application.Common.Models;
using EMS.Infrastructure.Common.Options;
using EMS.Infrastructure.Identity.Models;
using Microsoft.AspNetCore.Identity;
using Microsoft.Extensions.Options;

namespace EMS.Infrastructure.Identity
{
    public class IdentityService : IIdentityService
    {
        private readonly UserManager<ApplicationUser> _userManager;
        private readonly IApplicationDbContext _context;
        private readonly ITokenService _tokenService;
        private readonly RoleManager<ApplicationRole> _roleManager;
        private readonly IUserClaimsPrincipalFactory<ApplicationUser> _userClaimsPrincipalFactory;
        private readonly JwtSettings _jwtSettings;

        public IdentityService(UserManager<ApplicationUser> userManager, IApplicationDbContext context,
            ITokenService tokenService, IOptions<JwtSettings> jwtSettings, RoleManager<ApplicationRole> roleManager,
            IUserClaimsPrincipalFactory<ApplicationUser> userClaimsPrincipalFactory
            )
        {
            _userManager = userManager;
            _context = context;
            _tokenService = tokenService;
            _roleManager = roleManager;
            _userClaimsPrincipalFactory = userClaimsPrincipalFactory;
            _jwtSettings = jwtSettings.Value;
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
            throw new NotImplementedException();

            var user = await _userManager.FindByIdAsync(userId);

            if (user == null)
            {
                return false;
            }

            var principal = await _userClaimsPrincipalFactory.CreateAsync(user);
            //var result = await _authenticationService.
        }

        public Task<Result> ChangePasswordAsync(string userId, string currentPassword, string newPassword, CancellationToken cancellationToken = default)
        {
            throw new NotImplementedException();
        }

        public Task<Result> UpdateUserAsync(string userId, string userName, CancellationToken cancellationToken = default)
        {
            throw new NotImplementedException();

        }

        public Task<Result> ValidateUserAsync(string userName, string password, CancellationToken cancellationToken = default)
        {
            throw new NotImplementedException();
        }
    }
}
