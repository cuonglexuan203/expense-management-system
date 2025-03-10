namespace EMS.Infrastructure.Common.Options
{
    public class CacheOptions
    {
        public const string Cache = "Redis";
        public string ConnectionString { get; set; } = default!;
        public string InstanceName { get; set; } = default!;
        public int DefaultExpiryTimeInMinutes { get; set; } = 60;
        public bool EnableLogging { get; set; } = true;
    }
}
