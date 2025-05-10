using EMS.Application.Common.Interfaces.Services.HttpClients;
using EMS.Infrastructure.Common.Options;
using Microsoft.Extensions.Logging;
using Microsoft.Extensions.Options;
using System.Text.Json.Serialization;
using System.Text.Json;
using EMS.Core.Constants;
using EMS.Application.Common.DTOs.Dispatcher;
using System.Net.Http.Json;

namespace EMS.Infrastructure.Services.HttpClients.DispatcherService
{
    public class DispatcherService : IDispatcherService
    {
        private readonly ILogger<DispatcherService> _logger;
        private readonly HttpClient _httpClient;
        private readonly DispatcherServiceOptions _options;
        private readonly JsonSerializerOptions _serializerOptions;

        public DispatcherService(
            ILogger<DispatcherService> logger,
            HttpClient httpClient,
            IOptions<DispatcherServiceOptions> options)
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

        public async Task<NotificationDispatchResponse?> SendNotification(NotificationDispatchRequest msg)
        {
            var response = await _httpClient.PostAsJsonAsync(DispatcherServiceEndpoints.SendNotification, msg, _serializerOptions);

            response.EnsureSuccessStatusCode();

            var result = await response.Content.ReadFromJsonAsync<NotificationDispatchResponse>(_serializerOptions);

            return result;
        }

        public async Task SendEmailAsync(EmailDispatchRequest msg)
        {
            try
            {
                var response = await _httpClient.PostAsJsonAsync(DispatcherServiceEndpoints.SendEmail, msg, _serializerOptions);

                response.EnsureSuccessStatusCode();

                _logger.LogInformation("Email successfully dispatched for {Email}",
                    msg.To);
            }
            catch (Exception ex)
            {
                _logger.LogError("Error calling Dispatcher service to send email for {Email}: {ErrorMsg}",
                    msg.To,
                    ex.Message);

                throw;
            }
        }
    }
}
