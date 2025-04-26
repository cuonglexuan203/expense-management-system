namespace EMS.Application.Common.Interfaces.Messaging
{
    public interface IMessageQueueService
    {
        Task EnqueueAsync<T>(string queueName, T message, CancellationToken cancellationToken = default);
        Task<T?> DequeueAsync<T>(string queueName, TimeSpan? timeout = null, CancellationToken cancellationToken = default);
        Task<long> GetQueueLengthAsync(string queueName, CancellationToken cancellationToken = default);
    }
}
