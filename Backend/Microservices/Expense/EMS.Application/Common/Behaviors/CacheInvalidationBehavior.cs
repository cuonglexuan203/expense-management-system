using EMS.Application.Common.Attributes;
using EMS.Application.Common.Interfaces.Services;
using MediatR;
using System.Reflection;

namespace EMS.Application.Common.Behaviors
{
    public class CacheInvalidationBehavior<TRequest, TResponse> : IPipelineBehavior<TRequest, TResponse>
        where TRequest : IRequest<TResponse>
    {
        private readonly IDistributedCacheService _cacheService;
        private readonly ICurrentUserService _currentUserService;

        public CacheInvalidationBehavior(
            IDistributedCacheService cacheService,
            ICurrentUserService currentUserService)
        {
            _cacheService = cacheService;
            _currentUserService = currentUserService;
        }

        public async Task<TResponse> Handle(TRequest request, RequestHandlerDelegate<TResponse> next, CancellationToken cancellationToken)
        {
            var response = await next();

            var invalidationCacheAttributes = request.GetType().GetCustomAttributes<InvalidateCacheAttribute>();

            foreach (var attribute in invalidationCacheAttributes)
            {
                var keyPrefix = attribute.KeyPrefix;

                if (attribute is UserInvalidateCacheAttribute userInvalidateCacheAttribute)
                {
                    if (string.IsNullOrEmpty(userInvalidateCacheAttribute.UserId))
                    {
                        userInvalidateCacheAttribute.UserId = _currentUserService.Id;
                    }

                    keyPrefix = userInvalidateCacheAttribute.GetUserKeyPrefix();
                }

                var pattern = $"{_cacheService.GetFullKey(keyPrefix)}:*";

                var keys = await _cacheService.GetKeysByPatternAsync(pattern);

                foreach (var key in keys)
                {
                    await _cacheService.RemoveAsync(key, true, cancellationToken);
                }
            }

            return response;
        }
    }
}
