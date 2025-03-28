using EMS.Infrastructure.SignalR;
using Microsoft.AspNetCore.SignalR;

namespace EMS.API.Hubs
{
    public class EMSHubBase<TClient>(
        SignalRConnectionManager connectionManager,
        ISignalRContextAccessor contextAccessor) : Hub<TClient>
        where TClient : class
    {
        private readonly SignalRConnectionManager _connectionManager = connectionManager;
        private readonly ISignalRContextAccessor _contextAccessor = contextAccessor;

        public override Task OnConnectedAsync()
        {
            _contextAccessor.SetContext(Context);

            var userId = Context.UserIdentifier;
            var ipAddress = GetClientIpAddress(Context);
            var userAgent = GetUserAgent(Context);

            if(!string.IsNullOrEmpty(userId))
            {
                _connectionManager.AddConnection(Context.ConnectionId, userId, ipAddress, userAgent);
            }

            return base.OnConnectedAsync();
        }

        public override Task OnDisconnectedAsync(Exception? exception)
        {
            _connectionManager.RemoveConnection(Context.ConnectionId);

            return base.OnDisconnectedAsync(exception);
        }
        private string? GetClientIpAddress(HubCallerContext context)
        {
            var httpContext = Context.GetHttpContext();
            if (httpContext != null)
            {
                var ip = httpContext.Request.Headers["X-Forwarded-For"].FirstOrDefault();
                if (string.IsNullOrEmpty(ip))
                {
                    ip = httpContext.Connection?.RemoteIpAddress?.MapToIPv4().ToString();
                }
                return ip;
            }

            return null;
        }

        private string? GetUserAgent(HubCallerContext context)
        {
            var httpContext = context.GetHttpContext();
            return httpContext?.Request.Headers.UserAgent.ToString();
        }
    }
}
