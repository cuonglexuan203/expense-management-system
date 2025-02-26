using EMS.Application.Common.Interfaces.Services;
using MediatR;
using Microsoft.Extensions.Logging;
using System.Diagnostics;

namespace EMS.Application.Common.Behaviors
{
    public class PerformanceBehavior<TRequest, TResponse> : IPipelineBehavior<TRequest, TResponse>
        where TRequest : IRequest<TResponse>
    {
        private readonly Stopwatch _timer;
        private readonly ILogger<PerformanceBehavior<TRequest, TResponse>> _logger;
        private readonly ICurrentUserService _user;
        private readonly IIdentityService _identityService;

        public PerformanceBehavior(ILogger<PerformanceBehavior<TRequest, TResponse>> logger, ICurrentUserService user, IIdentityService identityService)
        {
            _timer = new Stopwatch();

            _logger = logger;
            _user = user;
            _identityService = identityService;
        }
        public async Task<TResponse> Handle(TRequest request, RequestHandlerDelegate<TResponse> next, CancellationToken cancellationToken)
        {
            _timer.Start();
            var response = await next();
            _timer.Stop();

            var elapsedMilliseconds = _timer.ElapsedMilliseconds;

            if(elapsedMilliseconds > 5000)
            {
                var requestName = typeof(TRequest).Name;
                var userId = _user.Id ?? string.Empty;
                var userName = string.Empty;

                if(!string.IsNullOrEmpty(userId))
                {
                    userName = await _identityService.GetUserNameAsync(userId);
                }

                _logger.LogWarning("EMS Long Running Request: {RequestName} ({ElapsedMilliseconds} milliseconds) {@UserId} {@Username} {@Request}",
                    requestName, elapsedMilliseconds, userId, userName, request);
            }

            return response;
        }
    }
}
