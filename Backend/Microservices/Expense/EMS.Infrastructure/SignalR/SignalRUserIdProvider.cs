using Microsoft.AspNetCore.SignalR;
using System.Security.Claims;
namespace EMS.Infrastructure.SignalR
{
    public class SignalRUserIdProvider : IUserIdProvider
    {
        public string? GetUserId(HubConnectionContext connection)
        {
             return connection.User.FindFirst(ClaimTypes.NameIdentifier)?.Value;
            //return connection.UserIdentifier;
        }
    }
}
