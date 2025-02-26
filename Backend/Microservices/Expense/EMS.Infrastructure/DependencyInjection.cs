using EMS.Application.Common.Interfaces.DbContext;
using EMS.Application.Common.Interfaces.Services;
using EMS.Infrastructure.Identity;
using EMS.Infrastructure.Identity.Models;
using EMS.Infrastructure.Persistence.DbContext;
using EMS.Infrastructure.Persistence.Interceptors;
using EMS.Infrastructure.Services;
using Microsoft.AspNetCore.Identity;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Diagnostics;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.DependencyInjection.Extensions;

namespace EMS.Infrastructure
{
    public static class DependencyInjection
    {
        public static IServiceCollection AddInfrastructureServices(this IServiceCollection services, IConfiguration configuration)
        {
            services.AddSingleton(TimeProvider.System);
            services.TryAddScoped<ISaveChangesInterceptor, AuditableEntityInterceptor>();
            services.TryAddScoped<ITokenService, TokenService>();
            services.TryAddScoped<IIdentityService, IdentityService>();
            
            #region Adding DbContext
            services
                .AddDbContext<ApplicationDbContext>((sp, ob) =>
            {
                ob.AddInterceptors(sp.GetServices<ISaveChangesInterceptor>());

                ob.UseNpgsql(configuration.GetSection("DatabaseSettings:ConnectionString").Value, options =>
                {
                    options.MigrationsAssembly(typeof(ApplicationDbContext).Assembly.FullName);
                    options.EnableRetryOnFailure(3);
                });
            });

            services.TryAddScoped<IApplicationDbContext>(provider => provider.GetRequiredService<ApplicationDbContext>());
            services.TryAddScoped<ApplicationDbContextInitializer>();

            services
                .AddIdentityCore<ApplicationUser>(options =>
                {
                    options.Password.RequiredLength = 6;
                    options.Password.RequireDigit = false;
                    options.Password.RequireLowercase = false;
                    options.Password.RequireUppercase = false;
                    options.Password.RequireNonAlphanumeric = false;

                    options.SignIn.RequireConfirmedEmail = false;
                })
                .AddRoles<ApplicationRole>()
                .AddEntityFrameworkStores<ApplicationDbContext>()
                .AddDefaultTokenProviders();
            #endregion

            return services;
        }
    }
}
