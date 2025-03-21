using EMS.Application.Common.DTOs;
using EMS.Application.Common.Interfaces.Services.HttpClients;
using EMS.Infrastructure.Common.Options;
using Microsoft.Extensions.Logging;
using Microsoft.Extensions.Options;
using System.Net.Http.Json;

namespace EMS.Infrastructure.Services.HttpClients.AiService
{
    public class AiService : IAiService
    {
        private readonly ILogger<AiService> _logger;
        private readonly HttpClient _httpClient;
        private readonly AiServiceOptions _options;

        public AiService(
            ILogger<AiService> logger,
            HttpClient httpClient,
            IOptions<AiServiceOptions> options)
        {
            _logger = logger;
            _httpClient = httpClient;
            _options = options.Value;

            //
            ConfigureClient(_httpClient);
        }

        public void ConfigureClient(HttpClient httpClient)
        {
            httpClient.BaseAddress = new Uri(_options.BaseUrl);
        }

        public async Task<MessageExtractionResponse> ExtractTransactionAsync(MessageExtractionRequest request)
        {
            try
            {
                var response = await _httpClient.PostAsJsonAsync(AiServiceEndpoints.ExtractTransaction, request);

                response.EnsureSuccessStatusCode();

                var result = await response.Content.ReadFromJsonAsync<MessageExtractionResponse>();

                return result;
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error calling AI service for transaction extraction");

                return new MessageExtractionResponse
                {
                    Introduction = "Sorry, I couldn't process that request. Could you try rephrasing your request?",
                };
            }
        }
    }
}
