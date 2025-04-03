namespace EMS.Infrastructure.Common.Options
{
    public class AiServiceOptions
    {
        public const string AiService = "Services:Ai";
        public string BaseUrl { get; set; } = default!;
        public string ApiKey { get; set; } = default!;
    }
}
