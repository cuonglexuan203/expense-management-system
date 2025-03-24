using EMS.Application.Common.Interfaces.Messaging;
using Microsoft.Extensions.Logging;
using System.Runtime.CompilerServices;
using System.Threading.Channels;

namespace EMS.Infrastructure.Messaging
{
    public class ChannelMessageQueue<T> : IMessageQueue<T>
    {
        private readonly ILogger<ChannelMessageQueue<T>> _logger;
        private readonly Channel<T> _channel;

        public ChannelMessageQueue(ILogger<ChannelMessageQueue<T>> logger)
        {
            _logger = logger;
            _channel = Channel.CreateUnbounded<T>(new UnboundedChannelOptions
            {
                SingleReader = true,
                SingleWriter = false,
            });
        }
        public async Task EnqueueAsync(T message, CancellationToken cancellationToken = default)
        {
            _logger.LogDebug("Enqueueing message of type {MessageType}", typeof(T).Name);
            await _channel.Writer.WriteAsync(message, cancellationToken);
        }

        public async IAsyncEnumerable<T> DequeueAsync([EnumeratorCancellation] CancellationToken cancellationToken = default)
        {
            while (await _channel.Reader.WaitToReadAsync(cancellationToken))
            {
                while (_channel.Reader.TryRead(out var item))
                {
                    yield return item;
                }
            }
        }

    }
}
