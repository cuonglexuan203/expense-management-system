namespace EMS.Infrastructure.Services.HttpClients.AiService
{
    public static class AiServiceEndpoints
    {
        private const string _apiVersion = "/api/v1";
        public const string ExtractTransaction = $"{_apiVersion}/extractions/extract-transaction";
    }
}
