using EMS.Application.Common.Interfaces.Services;
using EMS.Infrastructure.SignalR;
using System.Security.Claims;

namespace EMS.API.Services
{
    public class CurrentUserService(
        IHttpContextAccessor httpContextAccessor,
        SignalRConnectionManager connectionManager,
        ISignalRContextAccessor signalRContextAccessor) : ICurrentUserService
    {
        private readonly IHttpContextAccessor _httpContextAccessor = httpContextAccessor;
        private readonly SignalRConnectionManager _signalRConnectionManager = connectionManager;
        private readonly ISignalRContextAccessor _signalRContextAccessor = signalRContextAccessor;

        public string? Id
        {
            get
            {
                var httpUserId = _httpContextAccessor.HttpContext?.User?.FindFirst(ClaimTypes.NameIdentifier)?.Value;
                if (!string.IsNullOrEmpty(httpUserId))
                {
                    return httpUserId;
                }

                var signalRContext = _signalRContextAccessor.Context;
                if (signalRContext != null)
                {
                    return signalRContext.UserIdentifier;
                }

                return null;
            }
        }


        public string? IpAddress
        {
            get
            {
                var httpContext = _httpContextAccessor.HttpContext;
                if (httpContext != null)
                {
                    var ip = httpContext.Request.Headers["X-Forwarded-For"].FirstOrDefault();
                    if (string.IsNullOrEmpty(ip))
                    {
                        ip = httpContext.Connection?.RemoteIpAddress?.MapToIPv4().ToString();
                    }
                    return ip;
                }

                var signalRContext = _signalRContextAccessor.Context;
                if (signalRContext != null)
                {
                    var connectionInfo = _signalRConnectionManager.GetConnectionInfo(signalRContext.ConnectionId);

                    return connectionInfo?.IpAddress;
                }

                return null;
            }
        }

        public string? UserAgent
        {
            get
            {
                var userAgent = _httpContextAccessor.HttpContext?.Request.Headers.UserAgent.ToString();
                if (!string.IsNullOrEmpty(userAgent))
                {
                    return userAgent;
                }

                var signalRContext = _signalRContextAccessor.Context;
                if (signalRContext != null)
                {
                    var connectionInfo = _signalRConnectionManager.GetConnectionInfo(signalRContext.ConnectionId);

                    return connectionInfo?.UserAgent;
                }

                return null;
            }
        }
    }
}
