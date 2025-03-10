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

        public CacheInvalidationBehavior(IDistributedCacheService cacheService)
        {
            _cacheService = cacheService;
        }

        public async Task<TResponse> Handle(TRequest request, RequestHandlerDelegate<TResponse> next, CancellationToken cancellationToken)
        {
            var response = await next();

            var invalidationCacheAttributes = request.GetType().GetCustomAttributes<InvalidateCacheAttribute>();

            foreach (var attribute in invalidationCacheAttributes)
            {
                var pattern = $"{_cacheService.GetFullKey(attribute.KeyPrefix)}:*";
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
