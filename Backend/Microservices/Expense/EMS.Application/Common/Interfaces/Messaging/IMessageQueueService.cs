using System.Text.Json;

namespace EMS.Application.Common.Interfaces.Messaging
{
    public interface IMessageQueueService
    {
        Task EnqueueAsync<T>(string queueName, T message, CancellationToken cancellationToken = default);
        Task<T?> DequeueAsync<T>(string queueName, TimeSpan? timeout = null, bool isFullName = false, JsonSerializerOptions? jsonSerializerOptions = default, CancellationToken cancellationToken = default);
        Task<long> GetQueueLengthAsync(string queueName, CancellationToken cancellationToken = default);
    }
}
