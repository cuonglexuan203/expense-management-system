using EMS.Application.Common.Interfaces.Services;
using EMS.Core.Constants;
using Microsoft.AspNetCore.Authentication;
using Microsoft.Extensions.Logging;
using Microsoft.Extensions.Options;
using System.Security.Claims;
using System.Text.Encodings.Web;

namespace EMS.Infrastructure.Authentication
{
    public class ApiKeyAuthenticationOptions : AuthenticationSchemeOptions
    {
        public const string DefaultScheme = AuthenticationSchemes.ApiKey;
        public string AuthorizationHeaderName { get; set; } = CustomHeaders.ApiKey;
        public string QueryStringParameterName { get; set; } = QueryStringParameters.ApiKey;
    }

    public class ApiKeyAuthenticationHandler : AuthenticationHandler<ApiKeyAuthenticationOptions>
    {
        private readonly ILogger<ApiKeyAuthenticationHandler> _logger;
        private readonly IApiKeyService _apiKeyService;

        public ApiKeyAuthenticationHandler(
            IOptionsMonitor<ApiKeyAuthenticationOptions> options,
            ILoggerFactory logger,
            UrlEncoder urlEncoder,
            IApiKeyService apiKeyService)
            : base(options, logger, urlEncoder)
        {
            _logger = logger.CreateLogger<ApiKeyAuthenticationHandler>();
            _apiKeyService = apiKeyService;
        }
        protected override async Task<AuthenticateResult> HandleAuthenticateAsync()
        {
            if (!Request.Headers.TryGetValue(Options.AuthorizationHeaderName, out var apiKeyHeaderValues))
            {
                if (!Request.Query.TryGetValue(Options.QueryStringParameterName, out var apiKeyQueryValues))
                {
                    _logger.LogDebug("No API Key provided");

                    return AuthenticateResult.NoResult();
                }

                apiKeyHeaderValues = apiKeyQueryValues;
            }

            var providedApiKey = apiKeyHeaderValues.FirstOrDefault();

            if (string.IsNullOrEmpty(providedApiKey))
            {
                _logger.LogDebug("Empty API Key provided");

                return AuthenticateResult.NoResult();
            }

            try
            {
                var isValid = await _apiKeyService.ValidateApiKeyAsync(providedApiKey);

                if (!isValid)
                {
                    _logger.LogWarning("Invalid key provided: {apiKey}",
                        providedApiKey.Substring(0, 5) + "...");

                    return AuthenticateResult.Fail("Invalid API Key");
                }

                var apiKey = (await _apiKeyService.GetApiKeyDetailsFromPlainTextAsync(providedApiKey))!;

                var claims = new List<Claim>
                {
                    new(ClaimTypes.NameIdentifier, apiKey.Id.ToString()),
                    new(ClaimTypes.Name, apiKey.Name),
                    new("auth_type", "api_key"),
                    new("owner_id", apiKey.OwnerId ?? "")
                };

                foreach (var scope in apiKey.Scopes)
                {
                    claims.Add(new("scope", scope.Scope));
                }

                var identity = new ClaimsIdentity(claims, Scheme.Name);
                var principal = new ClaimsPrincipal(identity);
                var ticket = new AuthenticationTicket(principal, Scheme.Name);

                _logger.LogInformation("API Key authentication successful for key Id: {keyId}", apiKey.Id);

                return AuthenticateResult.Success(ticket);
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Exception occurred during API key authentication");

                return AuthenticateResult.Fail("API Key authentication failed");
            }
        }
    }
}
