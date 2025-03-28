using Microsoft.AspNetCore.SignalR;

namespace EMS.Infrastructure.SignalR
{
    public interface ISignalRContextAccessor
    {
        HubCallerContext? Context { get; }
        void SetContext(HubCallerContext context);
    }

    public class SignalRContextAccessor : ISignalRContextAccessor
    {
        private static readonly AsyncLocal<HubCallerContextHolder> _hubCallerContextCurrent = new();
        public HubCallerContext? Context => _hubCallerContextCurrent.Value?.Context;

        public void SetContext(HubCallerContext context)
        {
            var holder = _hubCallerContextCurrent.Value;
            if (holder != null)
            {
                holder.Context = context;
            }
            else
            {
                _hubCallerContextCurrent.Value = new() { Context = context };
            }
        }

        private class HubCallerContextHolder
        {
            public HubCallerContext? Context;
        }
    }
}
