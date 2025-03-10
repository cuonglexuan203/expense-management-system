using EMS.Infrastructure.Common.Options;
using Microsoft.Extensions.Diagnostics.HealthChecks;
using Microsoft.Extensions.Options;
using StackExchange.Redis;

namespace EMS.Infrastructure.Cache
{
    public class RedisCacheHealthCheck : IHealthCheck
    {
        private readonly IConnectionMultiplexer _redis;
        private readonly CacheOptions _cacheOptions;

        public RedisCacheHealthCheck(IConnectionMultiplexer redis, IOptions<CacheOptions> cacheOptions)
        {
            _redis = redis ?? throw new ArgumentNullException(nameof(redis));
            _cacheOptions = cacheOptions.Value;
        }

        public async Task<HealthCheckResult> CheckHealthAsync(HealthCheckContext context, CancellationToken cancellationToken = default)
        {
            try
            {
                var db = _redis.GetDatabase();
                var pingResult = await db.PingAsync();

                var healthStatus = pingResult.TotalMilliseconds < 100
                    ? HealthStatus.Healthy
                    : HealthStatus.Degraded;

                return new(healthStatus, $"Redis response time: {pingResult.TotalMilliseconds}ms");
            }
            catch (Exception ex)
            {
                return new(HealthStatus.Unhealthy, $"Redis connection failed: {ex.Message}");
            }
        }
    }
}
