using EMS.Application.Common.Behaviors;
using EMS.Application.Common.Extensions;
using FluentValidation;
using Microsoft.Extensions.DependencyInjection;
using System.Reflection;

namespace EMS.Application
{
    public static class DependencyInjection
    {
        public static IServiceCollection AddApplicationServices(this IServiceCollection services)
        {
            services.AddAutoMapperConfiguration(
                Assembly.GetExecutingAssembly()
                //, Assembly.Load("EMS.Infrastructure")
                );

            services.AddValidatorsFromAssembly(Assembly.GetExecutingAssembly());

            services.AddMediatR(config =>
            {
                config.RegisterServicesFromAssembly(Assembly.GetExecutingAssembly());

                config.AddOpenBehavior(typeof(UnhandledExceptionBehavior<,>));
                config.AddOpenBehavior(typeof(ValidationBehavior<,>));
                config.AddOpenBehavior(typeof(PerformanceBehavior<,>));

                // Redis caching behaviors
                config.AddOpenBehavior(typeof(CachingBehavior<,>));
                config.AddOpenBehavior(typeof(CacheInvalidationBehavior<,>));
            });

            return services;
        }
    }
}
