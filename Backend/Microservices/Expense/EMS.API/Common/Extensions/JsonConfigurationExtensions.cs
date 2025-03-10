using Microsoft.AspNetCore.Mvc;
using System.Text.Json;
using System.Text.Json.Serialization;

namespace EMS.API.Common.Extensions
{
    public static class JsonConfigurationExtensions
    {
        public static IServiceCollection ConfigureJsonSerializer(this IServiceCollection services)
        {
            // Configure for controllers (MVC)
            services.Configure<JsonOptions>(options => ConfigureJsonSerializerOptions(options.JsonSerializerOptions));

            // Configure for minimal API
            services.Configure<Microsoft.AspNetCore.Http.Json.JsonOptions>(options => ConfigureJsonSerializerOptions(options.SerializerOptions));

            return services;
        }

        private static void ConfigureJsonSerializerOptions(JsonSerializerOptions options)
        {
            //options.DefaultIgnoreCondition = System.Text.Json.Serialization.JsonIgnoreCondition.WhenWritingNull;
            options.PropertyNamingPolicy = JsonNamingPolicy.CamelCase;
            options.PropertyNameCaseInsensitive = true;
            options.NumberHandling = JsonNumberHandling.AllowReadingFromString;
            options.ReferenceHandler = ReferenceHandler.IgnoreCycles;
            options.Converters.Add(new JsonStringEnumConverter());

        }
    }
}
