using System.Collections.Concurrent;

namespace EMS.Infrastructure.SignalR
{
    public class SignalRConnectionManager
    {
        private readonly ConcurrentDictionary<string, UserConnectionInfo> _userConnections = new();

        public void AddConnection(
            string connectionId,
            string userId,
            string? ipAddress,
            string? userAgent)
        {
            _userConnections[connectionId] = new()
            {
                ConnectionId = connectionId,
                UserId = userId,
                IpAddress = ipAddress,
                UserAgent = userAgent
            };
        }

        public bool RemoveConnection(string connectionId)
        {
            return _userConnections.TryRemove(connectionId, out _);
        }

        public UserConnectionInfo? GetConnectionInfo(string connectionId)
        {
            return _userConnections.TryGetValue(connectionId, out var info) ? info : null;
        }

        public string? GetUserIdByConnectionId(string connectionId)
        {
            return GetConnectionInfo(connectionId)?.UserId;
        }

        public IEnumerable<string> GetConnectionIdByUserId(string userId)
        {
            return _userConnections.Where(x => x.Value.UserId == userId)
                                .Select(x => x.Key);
        }
    }

    public class UserConnectionInfo
    {
        public string? UserId { get; set; }
        public string? IpAddress { get; set; }
        public string? UserAgent { get; set; }
        public string ConnectionId { get; set; } = default!;
    }
}

