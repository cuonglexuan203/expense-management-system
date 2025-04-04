using EMS.Infrastructure.Authentication;
using Microsoft.AspNetCore.Authentication;

namespace EMS.Infrastructure.Common.Extensions
{
    public static class AuthenticationBuilderExtensions
    {
        public static AuthenticationBuilder AddApiKeyAuthentication(
            this AuthenticationBuilder builder,
            Action<ApiKeyAuthenticationOptions>? configureOptions = default)
        {
            builder.AddScheme<ApiKeyAuthenticationOptions, ApiKeyAuthenticationHandler>(
                ApiKeyAuthenticationOptions.DefaultScheme,
                ApiKeyAuthenticationOptions.DefaultScheme,
                configureOptions ?? (options => { }));

            return builder;
        }
    }
}
