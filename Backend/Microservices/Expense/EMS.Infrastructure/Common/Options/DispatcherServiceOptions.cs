namespace EMS.Infrastructure.Common.Options
{
    public class DispatcherServiceOptions
    {
        public const string DispatcherService = "Services:Dispatcher";
        public string BaseUrl { get; set; } = default!;
        public string ApiKey { get; set; } = default!;
    }
}
