namespace EMS.Infrastructure.Services.HttpClients.AiService
{
    public static class AiServiceEndpoints
    {
        private const string _apiVersion = "/api/v1";
        public const string ExtractTransaction = $"{_apiVersion}/extractions/text";
        public const string ExtractTransactionFromImages = $"{_apiVersion}/extractions/image";
        public const string ExtractTransactionFromAudios = $"{_apiVersion}/extractions/audio";
        public const string SwarmAssistant = $"{_apiVersion}/assistant/swarm";
        public const string SupervisorAssistant = $"{_apiVersion}/assistant/supervisor";
    }
}
