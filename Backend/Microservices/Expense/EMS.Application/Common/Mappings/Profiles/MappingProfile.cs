using AutoMapper;
using System.Reflection;

namespace EMS.Application.Common.Mappings.Profiles
{
    public class MappingProfile : Profile
    {
        public MappingProfile()
        {

        }

        public MappingProfile(params Assembly[] assemblies)
        {
            ApplyMappingsFromAssemblies(assemblies);
        }

        private void ApplyMappingsFromAssemblies(Assembly[] assemblies)
        {
            var types = assemblies
                .SelectMany(a => a.GetExportedTypes())
                .Where(t => t.GetInterfaces().Any(i =>
                i.IsGenericType &&
                (i.GetGenericTypeDefinition() == typeof(IMapFrom<>) ||
                i.GetGenericTypeDefinition() == typeof(IMapTo<>))))
                .ToList();

            foreach (var type in types)
            {
                var instance = Activator.CreateInstance(type);
                var mapFromMethods = type.GetMethods()
                    .Where(m =>
                    m.Name == EMS.Core.Constants.Mappings.Mapping &&
                    m.GetParameters().Length == 1 &&
                    m.GetParameters()[0].ParameterType == typeof(Profile))
                    .ToList();

                if (mapFromMethods.Any())
                {
                    foreach (var method in mapFromMethods)
                    {
                        method.Invoke(instance, [this]);
                    }
                }
                else
                {
                    ApplyConventionalMappings(type);
                }
            }
        }

        private void ApplyConventionalMappings(Type type)
        {
            var mapFromInterfaces = type.GetInterfaces()
                .Where(i => i.IsGenericType &&
                i.GetGenericTypeDefinition() == typeof(IMapFrom<>))
                .ToList();

            foreach (var mapFromInterface in mapFromInterfaces)
            {
                var sourceType = mapFromInterface.GetGenericArguments()[0];
                var mappingMethod = typeof(MappingProfile).GetMethod(nameof(CreateMap), BindingFlags.Instance | BindingFlags.NonPublic);

                mappingMethod
                    ?.MakeGenericMethod(sourceType, type)
                    .Invoke(this, null);
            }

            var mapToInterfaces = type.GetInterfaces()
                .Where(i => i.IsGenericType &&
                i.GetGenericTypeDefinition() == typeof(IMapTo<>))
                .ToList();

            foreach (var mapToInterface in mapToInterfaces)
            {
                var destinationType = mapToInterface.GetGenericArguments()[0];
                var mappingMethod = typeof(MappingProfile).GetMethod(nameof(CreateMap), BindingFlags.Instance | BindingFlags.NonPublic);

                mappingMethod
                    ?.MakeGenericMethod(type, destinationType)
                    .Invoke(this, null);
            }
        }

        private new void CreateMap<TSource, TDestination>()
            where TSource : class
            where TDestination : class
        {
            base.CreateMap<TSource, TDestination>();
        }
    }
}
