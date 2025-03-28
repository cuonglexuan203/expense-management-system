using EMS.Application.Common.Interfaces.DbContext;
using EMS.Application.Common.Interfaces.Messaging;
using EMS.Application.Common.Interfaces.Services;
using EMS.Application.Common.Interfaces.Services.HttpClients;
using EMS.Application.Features.Categories.Services;
using EMS.Application.Features.Chats.Common.Services;
using EMS.Application.Features.Chats.Finance.Messaging;
using EMS.Application.Features.Transactions.Services;
using EMS.Application.Features.Wallets.Services;
using EMS.Infrastructure.BackgroundJobs;
using EMS.Infrastructure.Common.Extensions;
using EMS.Infrastructure.Common.Options;
using EMS.Infrastructure.Identity;
using EMS.Infrastructure.Identity.Models;
using EMS.Infrastructure.Messaging;
using EMS.Infrastructure.Persistence.DbContext;
using EMS.Infrastructure.Persistence.Interceptors;
using EMS.Infrastructure.Services;
using EMS.Infrastructure.Services.HttpClients.AiService;
using EMS.Infrastructure.SignalR;
using Microsoft.AspNetCore.Identity;
using Microsoft.AspNetCore.SignalR;
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
            services.Configure<AiServiceOptions>(configuration.GetSection(AiServiceOptions.AiService));

            #region Add services
            AddSingletonServices(services);
            AddScopedServices(services);
            #endregion

            AddHttpClients(services);

            AddBackgroundJobs(services);

            AddDbContexts(services, configuration);

            services.AddRedisCaching(configuration);

            return services;
        }

        private static void AddHttpClients(IServiceCollection services)
        {
            services.AddHttpClient<IAiService, AiService>();
        }

        private static void AddScopedServices(IServiceCollection services)
        {
            services.TryAddScoped<ISaveChangesInterceptor, AuditableEntityInterceptor>();
            services.TryAddScoped<ITokenService, TokenService>();
            services.TryAddScoped<IIdentityService, IdentityService>();
            services.TryAddScoped<IWalletService, WalletService>();
            services.TryAddScoped<ITransactionService, TransactionService>();
            services.TryAddScoped<ICategoryService, CategoryService>();
            services.TryAddScoped<IUserPreferenceService, UserPreferenceService>();
            services.TryAddScoped<IChatThreadService, ChatThreadService>();
            services.TryAddScoped<IDatabaseTransactionManager, DatabaseTransactionManager>();
        }

        private static void AddSingletonServices(IServiceCollection services)
        {
            services.AddSingleton(TimeProvider.System);
            services.AddSingleton<IMessageQueue<TransactionProcessingMessage>,
                ChannelMessageQueue<TransactionProcessingMessage>>();

            // SignalR
            services.TryAddSingleton<SignalRConnectionManager>();
            services.TryAddSingleton<IUserIdProvider, SignalRUserIdProvider>();
            services.TryAddSingleton<ISignalRContextAccessor, SignalRContextAccessor>();
        }

        private static void AddBackgroundJobs(IServiceCollection services)
        {
            services.AddHostedService<TransactionProcessingService>();
        }

        private static void AddDbContexts(IServiceCollection services, IConfiguration configuration)
        {
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
        }
    }
}
