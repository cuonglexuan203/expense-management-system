using EMS.Application.Common.Interfaces.Services;
using EMS.Infrastructure.Cache;
using EMS.Infrastructure.Common.Options;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.DependencyInjection.Extensions;
using StackExchange.Redis;

namespace EMS.Infrastructure.Common.Extensions
{
    public static class ServiceCollectionExtensions
    {
        public static IServiceCollection AddRedisCaching(this IServiceCollection services, IConfiguration configuration)
        {
            services.Configure<CacheOptions>(configuration.GetSection(CacheOptions.Cache));
            var redisConfig = configuration.GetSection(CacheOptions.Cache).Get<CacheOptions>();

            services.AddSingleton<IConnectionMultiplexer>(sp =>
            {
                var configOptions = ConfigurationOptions.Parse(redisConfig!.ConnectionString);
                configOptions.AbortOnConnectFail = false;
                return ConnectionMultiplexer.Connect(configOptions);
            });

            services.TryAddSingleton<IDistributedCacheService, RedisCacheService>();

            services.AddHealthChecks()
                .AddCheck<RedisCacheHealthCheck>("redis_cache", tags: ["cache", "redis"]);

            return services;
        }
    }
}
