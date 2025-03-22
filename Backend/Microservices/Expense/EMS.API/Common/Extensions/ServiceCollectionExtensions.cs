using System.Text.Json;

namespace EMS.API.Common.Extensions
{
    public static class ServiceCollectionExtensions
    {
        public static IServiceCollection ConfigureSignalR(this IServiceCollection services)
        {
            services.AddSignalR(options =>
            {
                options.EnableDetailedErrors = true; // Development only
                options.KeepAliveInterval = TimeSpan.FromMinutes(1);
                options.ClientTimeoutInterval = TimeSpan.FromMinutes(2);
                options.MaximumReceiveMessageSize = 64 * 1024; // 64KB
                options.StreamBufferCapacity = 20;
            })
                .AddJsonProtocol(options =>
            {
                options.PayloadSerializerOptions.PropertyNamingPolicy = JsonNamingPolicy.CamelCase;
            });

            return services;
        }
    }
}
