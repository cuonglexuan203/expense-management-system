using EMS.Application.Common.Interfaces.Services;
using MediatR.Pipeline;
using Microsoft.Extensions.Logging;

namespace EMS.Application.Common.Behaviors
{
    public class LoggingBehavior<TRequest> : IRequestPreProcessor<TRequest>
        where TRequest : notnull
    {
        private readonly ILogger<LoggingBehavior<TRequest>> _logger;
        private readonly IUser _user;
        private readonly IIdentityService _identityService;

        public LoggingBehavior(ILogger<LoggingBehavior<TRequest>> logger, IUser user, IIdentityService identityService)
        {
            _logger = logger;
            _user = user;
            _identityService = identityService;
        }
        public async Task Process(TRequest request, CancellationToken cancellationToken)
        {
            var requestName = typeof(TRequest).Name;
            var userId = _user.Id ?? string.Empty;

            var userName = string.Empty;

            if (!string.IsNullOrEmpty(userId))
            {
                userName = await _identityService.GetUserNameAsync(userId);
            }

            _logger.LogInformation("EMS request: {RequestName} {@UserId} {@UserName} {@Request}", request, userId, userName, request);
        }
    }
}
