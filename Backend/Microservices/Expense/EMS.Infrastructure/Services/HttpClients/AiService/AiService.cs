using EMS.Application.Common.DTOs;
using EMS.Application.Common.Interfaces.Services.HttpClients;
using EMS.Core.Constants;
using EMS.Infrastructure.Common.Options;
using Microsoft.Extensions.Logging;
using Microsoft.Extensions.Options;
using System.Net.Http.Json;
using System.Text.Json;
using System.Text.Json.Serialization;

namespace EMS.Infrastructure.Services.HttpClients.AiService
{
    public class AiService : IAiService
    {
        private readonly ILogger<AiService> _logger;
        private readonly HttpClient _httpClient;
        private readonly AiServiceOptions _options;
        private readonly JsonSerializerOptions _serializerOptions;

        public AiService(
            ILogger<AiService> logger,
            HttpClient httpClient,
            IOptions<AiServiceOptions> options)
        {
            _logger = logger;
            _httpClient = httpClient;
            _options = options.Value;
            _serializerOptions = new JsonSerializerOptions
            {
                PropertyNamingPolicy = JsonNamingPolicy.SnakeCaseLower,
                Converters = { new JsonStringEnumConverter() }
            };
            //
            ConfigureClient(_httpClient);
        }

        public void ConfigureClient(HttpClient httpClient)
        {
            httpClient.BaseAddress = new Uri(_options.BaseUrl);
            httpClient.DefaultRequestHeaders.Add(CustomHeaders.ApiKey, _options.ApiKey);
        }

        public async Task<MessageExtractionResponse> ExtractTransactionAsync(MessageExtractionRequest request)
        {
            try
            {
                var response = await _httpClient.PostAsJsonAsync(AiServiceEndpoints.ExtractTransaction, request, _serializerOptions);

                response.EnsureSuccessStatusCode();

                var result = await response.Content.ReadFromJsonAsync<MessageExtractionResponse>(_serializerOptions);

                return result;
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error calling AI service for transaction extraction");

                return GetFailedExtractionResponse();
            }
        }

        public async Task<MessageExtractionResponse> ExtractTransactionFromImagesAsync(MessageWithFilesExtractionRequest request)
        {
            try
            {
                var response = await _httpClient.PostAsJsonAsync(AiServiceEndpoints.ExtractTransactionFromImages, request, _serializerOptions);

                response.EnsureSuccessStatusCode();

                var result = await response.Content.ReadFromJsonAsync<MessageExtractionResponse>(_serializerOptions);

                return result;
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error calling AI service for transaction extraction");

                return GetFailedExtractionResponse();
            }
        }

        public async Task<MessageExtractionResponse> ExtractTransactionFromAudiosAsync(MessageWithFilesExtractionRequest request)
        {
            try
            {
                var response = await _httpClient.PostAsJsonAsync(AiServiceEndpoints.ExtractTransactionFromAudios, request, _serializerOptions);

                response.EnsureSuccessStatusCode();

                var result = await response.Content.ReadFromJsonAsync<MessageExtractionResponse>(_serializerOptions);

                return result;
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error calling AI service for transaction extraction");

                return GetFailedExtractionResponse();
            }
        }

        private MessageExtractionResponse GetFailedExtractionResponse()
        {
            return new MessageExtractionResponse
            {
                Introduction = "Sorry, I couldn't process that request. Could you try rephrasing your request?",
            };
        }
    }
}
