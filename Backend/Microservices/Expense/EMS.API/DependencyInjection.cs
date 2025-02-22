using EMS.Core.Constants;

namespace EMS.API
{
    public static class DependencyInjection
    {
        public static void AddApiServices(this IServiceCollection services)
        {
            services.AddControllers();
            services.AddAuthentication();
            services.AddAuthorization(options => options.AddPolicy(Policies.CanPurge, policy => policy.RequireRole(Roles.Administrator));
            services.AddProblemDetails();
        }
    }
}
