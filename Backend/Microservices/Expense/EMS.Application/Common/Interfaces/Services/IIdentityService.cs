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
    }
}
