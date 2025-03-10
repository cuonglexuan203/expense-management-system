using EMS.Application.Common.Attributes;
using EMS.Application.Common.Interfaces.Services;
using MediatR;
using System.Reflection;

namespace EMS.Application.Common.Behaviors
{
    public class CachingBehavior<TRequest, TResponse> : IPipelineBehavior<TRequest, TResponse>
        where TRequest : IRequest<TResponse>
    {
        private readonly IDistributedCacheService _cacheService;
        private readonly ICurrentUserService _currentUserService;

        public CachingBehavior(IDistributedCacheService cacheService, ICurrentUserService currentUserService)
        {
            _cacheService = cacheService;
            _currentUserService = currentUserService;
        }

        public async Task<TResponse> Handle(TRequest request, RequestHandlerDelegate<TResponse> next, CancellationToken cancellationToken)
        {
            var cacheAttribute = request.GetType().GetCustomAttribute<CacheableQueryAttribute>();

            if (cacheAttribute == null)
            {
                return await next();
            }

            if(cacheAttribute is UserCacheableQueryAttribute userCacheAttribute)
            {
                userCacheAttribute.UserId = _currentUserService.Id!;
            }

            var cacheKey = cacheAttribute.GenerateCacheKey(request);

            return await _cacheService.GetOrSetAsync(
                cacheKey,
                async () => await next(),
                TimeSpan.FromMinutes(cacheAttribute.ExpirationMinutes),
                cancellationToken
                );
        }
    }
}
