using EMS.Application.Common.DTOs.Dispatcher;
using EMS.Application.Common.Models;
using EMS.Application.Features.Profiles.Dtos;

namespace EMS.Application.Common.Interfaces.Services
{
    public interface IIdentityService
    {
        Task<(Result Result, string UserId)> CreateUserAsync(string userName, string password, UserDto userDto, CancellationToken cancellationToken = default);
        Task<Result> DeleteUserAsync(string userId, CancellationToken cancellationToken = default);
        Task<bool> IsInRoleAsync(string userId, string role, CancellationToken cancellationToken = default);
        Task<Result> AddToRoleAsync(string userId, string role, CancellationToken cancellationToken = default);
        Task<Result> RemoveFromRoleAsync(string userId, string role, CancellationToken cancellationToken = default);
        Task<bool> AuthorizeAsync(string userId, string policyName, CancellationToken cancellationToken = default);
        Task<Result> UpdateUserAsync(string userId, UserDto userDto, CancellationToken cancellationToken = default);
        Task<Result> ChangePasswordAsync(string userId, string currentPassword, string newPassword, CancellationToken cancellationToken = default);
        Task<(Result result, string? userId)> ValidateUserAsync(string userName, string password, CancellationToken cancellationToken = default);
        Task<string?> GetUserNameAsync(string userId, CancellationToken cancellationToken = default);
        Task<Result> CreateRoleAsync(string roleName, CancellationToken cancellationToken = default);
        Task<UserDto?> GetUserAsync(string userId, CancellationToken cancellationToken = default);

        // Reset password
        Task<(Result<EmailDispatchRequest> Result, string? PasswordResetToken)> GeneratePasswordResetEmailAsync(
            string email,
            CancellationToken cancellationToken = default);
        Task<Result> ResetPasswordAsync(string email, string token, string newPassword, CancellationToken cancellationToken = default);
    }
}