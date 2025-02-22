using EMS.Infrastructure.Identity.Models;
using EMS.Infrastructure.Persistence.DbContext;
using Microsoft.AspNetCore.Identity;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.DependencyInjection;

namespace EMS.Infrastructure
{
    public static class DependencyInjection
    {
        public static void AddInfrastructureServices(this IServiceCollection services, IConfiguration configuration)
        {
            #region Adding DbContext
            services.AddDbContext<ApplicationDbContext>(ob => ob.UseNpgsql(configuration.GetSection("DatabaseSettings:ConnectionString").Value, options =>
            {
                options.MigrationsAssembly(typeof(ApplicationDbContext).Assembly.FullName);
                options.EnableRetryOnFailure(3);
            }));
            services.AddIdentity<ApplicationUser, ApplicationRole>(options =>
            {
                options.Password.RequiredLength = 6;
                options.Password.RequireDigit = false;
                options.Password.RequireNonAlphanumeric = false;
                options.Password.RequireLowercase = false;
                options.Password.RequireUppercase = false;

                options.SignIn.RequireConfirmedAccount = false;
            })
                .AddEntityFrameworkStores<ApplicationDbContext>()
                .AddDefaultTokenProviders();
            #endregion

            #region Adding services
            services.AddSingleton<TimeProvider>();
            #endregion
        }
    }
}
