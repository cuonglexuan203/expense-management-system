using EMS.Application.Common.Interfaces.DbContext;
using Microsoft.EntityFrameworkCore;
using System.Reflection;

namespace EMS.Infrastructure.Common.Extensions
{
    public static class ModelBuilderExtensions
    {
        public static ModelBuilder AddPostgreExtensions(this ModelBuilder builder)
        {
            builder.HasPostgresExtension("unaccent");

            return builder;
        }

        public static ModelBuilder MapPostgreDbFunctions(this ModelBuilder builder)
        {
            typeof(DatabaseFunctions)
                .GetMethods(BindingFlags.Public | BindingFlags.Static)
                .Where(m => m.GetCustomAttribute<DbFunctionAttribute>() != null)
                .ToList()
                .ForEach(m => builder.HasDbFunction(m));

            return builder;
        }
    }
}
