using EMS.Application.Common.Interfaces.Messaging;
using EMS.Application.Common.Interfaces.Services;
using EMS.Infrastructure.Cache;
using EMS.Infrastructure.Common.Options;
using EMS.Infrastructure.Messaging;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.DependencyInjection.Extensions;
using StackExchange.Redis;

namespace EMS.Infrastructure.Common.Extensions
{
    public static class ServiceCollectionExtensions
    {
        public static IServiceCollection AddRedisService(this IServiceCollection services, IConfiguration configuration)
        {
            services.Configure<RedisOptions>(configuration.GetSection(RedisOptions.Redis));
            var redisConfig = configuration.GetSection(RedisOptions.Redis).Get<RedisOptions>();

            services.AddSingleton<IConnectionMultiplexer>(sp =>
            {
                var configOptions = ConfigurationOptions.Parse(redisConfig!.ConnectionString);
                configOptions.AbortOnConnectFail = false;
                configOptions.SyncTimeout = 120_000;
                return ConnectionMultiplexer.Connect(configOptions);
            });

            services.TryAddSingleton<IDistributedCacheService, RedisCacheService>();
            services.TryAddSingleton<IMessageQueueService, RedisMessageQueueService>();

            services.AddHealthChecks()
                .AddCheck<RedisCacheHealthCheck>("redis_cache", tags: ["cache", "redis"]);

            return services;
        }
    }
}
