namespace EMS.Infrastructure.Common.Options
{
    public class RedisOptions
    {
        public const string Redis = "Redis";
        public string ConnectionString { get; set; } = default!;
        public string InstanceName { get; set; } = default!;
        public int DefaultExpiryTimeInMinutes { get; set; } = 60;
        public bool EnableLogging { get; set; } = true;
        public MessageQueuesOptions MessageQueues { get; set; } = new MessageQueuesOptions();
    }

    public class MessageQueuesOptions
    {
        public string NotificationExtractionQueue { get; set; } = "notification-extraction";
        public string EventProcessingQueueName { get; set; } = "event:processing";
    }
}
