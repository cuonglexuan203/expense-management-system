namespace EMS.API
{
    public static class DependencyInjection
    {
        public static void AddApiServices(this IServiceCollection services)
        {
            services.AddControllers();
            services.AddAuthentication();
            services.AddAuthorization();
            services.AddProblemDetails();
        }
    }
}
