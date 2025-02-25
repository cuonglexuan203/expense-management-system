using EMS.Application.Common.Models;

namespace EMS.Application.Common.Interfaces.Services
{
    public interface IIdentityService
    {
        Task<string?> GetUserNameAsync(string userId);
        Task<bool> IsInRoleAsync(string userId, string roleName);
        Task<bool> AuthorizeAsync(string userId, string policyName);
        Task<(Result result, string userId)> CreateUserAsync(string userName, string password);
        Task<Result> DeleteUserAsync(string userId);

        //

        // Authentication
        Task<TokenResponse> LoginAsync(string email, string password);
        Task LogoutAsync(string accessToken);
        Task<TokenResponse> RefreshTokenAsync(string accessToken, string refreshToken);

        // User Management
        Task<Result> RegisterAsync(string email, string password);
        Task<string> GenerateEmailConfirmationTokenAsync(string email);
        Task<Result> ConfirmEmailAsync(string userId, string token);
        Task RequestPasswordResetAsync(string email);
        Task<Result> ResetPasswordAsync(string email, string token, string newPassword);

        // Token Management
        Task RevokeRefreshTokensForUser(string userId);
    }
}
