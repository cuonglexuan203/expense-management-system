using EMS.Application.Common.Mappings.Profiles;
using Microsoft.Extensions.DependencyInjection;
using System.Reflection;

namespace EMS.Application.Common.Extensions
{
    public static class ServiceCollectionExtensions
    {
        public static IServiceCollection AddAutoMapperConfiguration(this IServiceCollection services, params Assembly[] assemblies)
        {
            services.AddAutoMapper(config =>
            {
                config.ShouldMapProperty = p => p.GetMethod.IsPublic || p.GetMethod.IsAssembly;
                config.ShouldMapField = f => false;
                config.AddProfile(new MappingProfile(assemblies));
            }, assemblies);

            return services;
        }
    }
}
