using EMS.Application.Common.Interfaces.Services;
using System.Security.Claims;

namespace EMS.API.Services
{
    public class CurrentUserService : IUser
    {
        private readonly IHttpContextAccessor _accessor;

        public CurrentUserService(IHttpContextAccessor accessor)
        {
            _accessor = accessor;
        }
        public string? Id => _accessor.HttpContext?.User?.FindFirst(ClaimTypes.NameIdentifier)?.Value;

        public string? IpAddress
        {
            get
            {
                var ip = _accessor.HttpContext?.Request.Headers["X-Forwarded-For"].FirstOrDefault();
                if (string.IsNullOrEmpty(ip))
                {
                    ip = _accessor.HttpContext?.Connection?.RemoteIpAddress?.MapToIPv4().ToString();
                }
                return ip;
            }
        }

        public string? UserAgent => _accessor.HttpContext?.Request.Headers.UserAgent.ToString();
    }
}
