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

                await _db.ListLeftPushAsync(fullQueueName, serializedMessage);

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

        public async Task<T?> DequeueAsync<T>(string queueName, TimeSpan? timeout = null, CancellationToken cancellationToken = default)
        {
            try
            {
                var fullQueueName = GetFullQueueName(queueName);

                var result = await _db.ListRightPopAsync(fullQueueName);

                if (result.IsNull)
                {
                    return default;
                }

                var serializedValue = result.ToString();
                if(_redisOptions.EnableLogging)
                {
                    _logger.LogInformation("Message dequeued from {QueueName}", fullQueueName);
                }

                return JsonSerializer.Deserialize<T>(serializedValue, _serializerOptions);
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
