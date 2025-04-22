using EMS.Application.Common.Interfaces.Services;
using EMS.Infrastructure.Common.Options;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Logging;
using Microsoft.Extensions.Options;
using StackExchange.Redis;
using System.Text.Json;

namespace EMS.Infrastructure.Cache
{
    public class RedisCacheService : IDistributedCacheService
    {
        private readonly ILogger<RedisCacheService> _logger;
        private readonly IConnectionMultiplexer _redis;
        private readonly JsonSerializerOptions _options;
        private readonly IDatabase _db;
        private readonly RedisOptions _redisOptions;

        public RedisCacheService(
            ILogger<RedisCacheService> logger,
            IConnectionMultiplexer redis,
            IOptions<RedisOptions> redisOptions,
            IOptions<JsonOptions> options
            )
        {
            _logger = logger;
            _redis = redis;
            _db = redis.GetDatabase();
            _redisOptions = redisOptions.Value;
            _options = options.Value.JsonSerializerOptions;
        }

        public async Task<T?> GetAsync<T>(string key, CancellationToken cancellationToken = default)
        {
            try
            {
                var fullKey = GetFullKey(key);
                string? cachedValue = await _db.StringGetAsync(fullKey);

                if (string.IsNullOrEmpty(cachedValue))
                {
                    LogCacheMiss(key);
                    return default;
                }

                LogCacheHit(key);
                return JsonSerializer.Deserialize<T>(cachedValue, _options);
            }
            catch (Exception ex)
            {
                LogCacheError(ex, key);
                return default;
            }
        }

        public async Task<T?> GetAsync<T>(string key, T? defaultValue, CancellationToken cancellationToken = default)
        {
            return await GetAsync<T>(key, cancellationToken) ?? defaultValue;
        }


        public async Task SetAsync<T>(string key, T value, TimeSpan? expiryTime = null, CancellationToken cancellationToken = default)
        {
            if (value == null)
            {
                LogCacheWarning($"Attempted to cache null value for key: {key}");
                return;
            }

            try
            {
                string fullKey = GetFullKey(key);
                string serializedValue = JsonSerializer.Serialize(value, _options);
                var expiry = expiryTime ?? TimeSpan.FromMinutes(_redisOptions.DefaultExpiryTimeInMinutes);

                await _db.StringSetAsync(fullKey, serializedValue, expiry);

                LogCacheInfo($"Value cached for key: {fullKey} with expiry: {expiry}");
            }
            catch (Exception ex)
            {
                LogCacheError(ex, key);
            }
        }

        public async Task RemoveAsync(string key, bool isFullKey = false, CancellationToken cancellationToken = default)
        {
            try
            {
                string fullKey = isFullKey ? key : GetFullKey(key);
                await _db.KeyDeleteAsync(fullKey);

                LogCacheInfo($"Cache entry removed: {fullKey}");
            }
            catch (Exception ex)
            {
                LogCacheError(ex, key);
            }
        }

        public async Task<T> GetOrSetAsync<T>(string key, Func<Task<T>> factory, TimeSpan? expiryTime = null, CancellationToken cancellationToken = default)
        {
            var cachedValue = await GetAsync<T>(key, cancellationToken);

            if (cachedValue != null)
            {
                return cachedValue;
            }

            var newValue = await factory();
            await SetAsync(key, newValue, expiryTime, cancellationToken);
            return newValue;
        }

        public async Task<bool> KeyExistsAsync(string key, CancellationToken cancellationToken = default)
        {
            try
            {
                var fullKey = GetFullKey(key);
                return await _db.KeyExistsAsync(fullKey);
            }
            catch (Exception ex)
            {
                LogCacheError(ex, key);
                return false;
            }
        }

        public async Task<bool> RefreshAsync(string key, CancellationToken cancellationToken = default)
        {
            try
            {
                var fullKey = GetFullKey(key);

                if (!await _db.KeyExistsAsync(fullKey))
                {
                    return false;
                }

                await _db.KeyExpireAsync(fullKey, TimeSpan.FromMinutes(_redisOptions.DefaultExpiryTimeInMinutes));
                LogCacheInfo($"Cache entry refreshed: {key}");
                return true;
            }
            catch (Exception ex)
            {
                LogCacheError(ex, key);
                return false;
            }
        }

        public string GetFullKey(string key)
            => string.IsNullOrEmpty(_redisOptions.InstanceName) ? key : $"{_redisOptions.InstanceName}:{key}";

        private void LogCacheHit(string key)
        {
            if (_redisOptions.EnableLogging)
            {
                _logger.LogDebug("Cache hit for key: {Key}", key);
            }
        }

        private void LogCacheMiss(string key)
        {
            if (_redisOptions.EnableLogging)
            {
                _logger.LogDebug("Cache miss for key: {Key}", key);
            }
        }

        private void LogCacheInfo(string message)
        {
            if (_redisOptions.EnableLogging)
            {
                _logger.LogInformation(message);
            }
        }

        private void LogCacheWarning(string message)
        {
            if (_redisOptions.EnableLogging)
            {
                _logger.LogWarning(message);
            }
        }

        private void LogCacheError(Exception ex, string key)
        {
            if (_redisOptions.EnableLogging)
            {
                _logger.LogError(ex, "Redis cache error for key {Key}: {msg}", key, ex.Message);
            }
        }

        public async Task<IEnumerable<string>> GetKeysByPatternAsync(string pattern, CancellationToken cancellationToken = default)
        {
            var keys = new List<string>();
            var server = _redis.GetServer(_redis.GetEndPoints()[0]);

            await foreach(var key in server.KeysAsync(pattern: pattern))
            {
                keys.Add(key.ToString());
            }

            return keys;
        }
    }
}
