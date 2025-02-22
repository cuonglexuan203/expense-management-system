using Asp.Versioning;
using EMS.API.Common.Middleware;
using EMS.API.Services;
using EMS.Application.Common.Interfaces.Services;
using EMS.Core.Constants;
using Microsoft.AspNetCore.Identity;
using Microsoft.Extensions.DependencyInjection.Extensions;
using Microsoft.OpenApi.Models;
using Serilog;

namespace EMS.API
{
    public static class DependencyInjection
    {
        public static void AddApiServices(this IServiceCollection services)
        {
            services.AddExceptionHandler<CustomExceptionHandler>();
            services.AddControllers();
            services.AddAuthentication()
                .AddBearerToken(IdentityConstants.BearerScheme);
            services.AddAuthorizationBuilder();
            services.AddAuthorization(options => options.AddPolicy(Policies.CanPurge, policy => policy.RequireRole(Roles.Administrator)));
            services.AddProblemDetails();
            services.AddHttpContextAccessor();
            services.TryAddScoped<IUser, CurrentUserService>();
            services.AddSerilog();

            AddSwaggerService(services);
            AddCors(services);

            #region Adding API versioning
            var defaultVersion = new ApiVersion(1, 0);
            services.AddApiVersioning(options =>
            {
                options.AssumeDefaultVersionWhenUnspecified = true;
                options.ReportApiVersions = true;
                options.DefaultApiVersion = defaultVersion;
                options.ApiVersionReader = new UrlSegmentApiVersionReader();
            }).AddApiExplorer(options =>
            {
                options.GroupNameFormat = "'v'VVV";
                options.SubstituteApiVersionInUrl = true;
                options.AssumeDefaultVersionWhenUnspecified = true;
                options.DefaultApiVersion = defaultVersion;
            });
            #endregion
        }

        private static void AddSwaggerService(IServiceCollection services)
        {
            services.AddEndpointsApiExplorer();
            services.AddSwaggerGen(options =>
            {
                options.SwaggerDoc("v1", new OpenApiInfo { Title = "EMS", Version = "1.0" });
                options.AddSecurityDefinition("Bearer", new OpenApiSecurityScheme
                {
                    In = ParameterLocation.Header,
                    Name = "Authorization",
                    Type = SecuritySchemeType.ApiKey,
                    Scheme = "bearer",
                    BearerFormat = "JWT",
                    Description = "Type into the textbox: Bearer {your JWT token}."
                });

                options.AddSecurityRequirement(new OpenApiSecurityRequirement
                {
                    {
                        new OpenApiSecurityScheme
                        {
                            Reference = new OpenApiReference
                            {
                                Type = ReferenceType.SecurityScheme,
                                Id = "Bearer",
                            }
                        },
                        Array.Empty<string>()
                    }
                });
            });
        }

        private static void AddCors(IServiceCollection services)
        {
            services.AddCors(options =>
            {
                options.AddPolicy("anonymous_policy", builder =>
                {
                    builder.SetIsOriginAllowed(_ => true)
                    .AllowAnyHeader()
                    .AllowAnyMethod()
                    .AllowCredentials();
                });
            });
        }
    }
}
