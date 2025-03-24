namespace EMS.Application.Common.Interfaces.Messaging
{
    public interface IMessageQueue<T>
    {
        Task EnqueueAsync(T message, CancellationToken cancellationToken = default);
        IAsyncEnumerable<T> DequeueAsync(CancellationToken cancellationToken = default);
    }
}
