using EMS.Application.Common.Interfaces.Messaging;
using EMS.Infrastructure.Common.Options;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Logging;
using Microsoft.Extensions.Options;
using StackExchange.Redis;
using System.Text.Json;

namespace EMS.Infrastructure.Messaging
{
    public class RedisMessageQueueService : IMessageQueueService
    {
        private readonly ILogger<RedisMessageQueueService> _logger;
        private readonly IConnectionMultiplexer _redis;
        private readonly IDatabase _db;
        private readonly JsonSerializerOptions _serializerOptions;
        private readonly RedisOptions _redisOptions;

        public RedisMessageQueueService(
            ILogger<RedisMessageQueueService> logger,
            IConnectionMultiplexer redis,
            IOptions<JsonOptions> jsonOptions,
            IOptions<RedisOptions> redisOptions)
        {
            _logger = logger;
            _redis = redis;
            _db = redis.GetDatabase();
            _serializerOptions = jsonOptions.Value.JsonSerializerOptions;
            _redisOptions = redisOptions.Value;
        }

        public async Task EnqueueAsync<T>(string queueName, T message, CancellationToken cancellationToken = default)
        {
            try
            {
                string fullQueueName = GetFullQueueName(queueName);
                string serializedMessage = JsonSerializer.Serialize(message, _serializerOptions);

                await _db.ListRightPushAsync(fullQueueName, serializedMessage);

                if (_redisOptions.EnableLogging)
                {
                    _logger.LogInformation("Message enqueued to {QueueName}", fullQueueName);
                }
            }
            catch (Exception ex)
            {
                _logger.LogError("Failed to enqueue message to {QueueName}: {ErrMsg}",
                    queueName,
                    ex.Message);

                throw;
            }
        }

        public async Task<T?> DequeueAsync<T>(string queueName, TimeSpan? timeout = null, bool isFullName = false, JsonSerializerOptions? jsonSerializerOptions = default, CancellationToken cancellationToken = default)
        {
            try
            {
                var fullQueueName = queueName;
                if (!isFullName)
                {
                    fullQueueName = GetFullQueueName(queueName);
                }

                #region Implement using blocking commands, problem: slowdown all other redis callers
                // NOTE: NRedisStack multiplexer does not support BLOCKING commands (e.g BLPop),
                // using a timeout of 0 will block the connection for all callers
                //var timeoutSeconds = timeout != null ? timeout.Value.TotalSeconds : 5;

                //var result = await _db.BLPopAsync(fullQueueName, timeoutSeconds);
                #endregion

                var result = await _db.ListLeftPopAsync(fullQueueName);
                if (result.IsNull)
                {
                    return default;
                }

                var serializedValue = result.ToString();
                if (_redisOptions.EnableLogging)
                {
                    _logger.LogInformation("Message dequeued from {QueueName}", fullQueueName);
                }

                return JsonSerializer.Deserialize<T>(serializedValue, jsonSerializerOptions ?? _serializerOptions);
            }
            catch (RedisTimeoutException)
            {
                return default;
            }
            catch (Exception ex)
            {
                _logger.LogError("Failed to dequeue message from {QueueName}: {ErrMsg}",
                    queueName,
                    ex.Message);

                throw;
            }
        }

        public async Task<long> GetQueueLengthAsync(string queueName, CancellationToken cancellationToken = default)
        {
            try
            {
                var fullQueueName = GetFullQueueName(queueName);
                return await _db.ListLengthAsync(fullQueueName);
            }
            catch (Exception ex)
            {
                _logger.LogError("Failed to get queue length for {QueueName}: {ErrMsg}",
                    queueName,
                    ex.Message);

                return -1;
            }
        }

        private string GetFullQueueName(string queueName)
        {
            return string.IsNullOrEmpty(_redisOptions.InstanceName)
                    ? queueName
                    : $"{_redisOptions.InstanceName}:{queueName}";
        }
    }
}
