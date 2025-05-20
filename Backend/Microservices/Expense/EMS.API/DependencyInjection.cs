using Asp.Versioning;
using EMS.API.Common.Middleware;
using EMS.API.Services;
using EMS.Application.Common.Interfaces.Services;
using EMS.Core.Constants;
using Microsoft.AspNetCore.Authentication.JwtBearer;
using Microsoft.Extensions.DependencyInjection.Extensions;
using Microsoft.OpenApi.Models;
using Microsoft.IdentityModel.Tokens;
using System.Text;
using EMS.Infrastructure.Common.Options;
using EMS.API.Common.Extensions;
using EMS.API.RealTime;
using EMS.Infrastructure.Authentication;
using EMS.Infrastructure.Common.Extensions;
using System.Security.Claims;
using EMS.Application.Features.ExtractedTransactions.Services;
using Microsoft.AspNetCore.Identity;

namespace EMS.API
{
    public static class DependencyInjection
    {
        public static IServiceCollection AddApiServices(this IServiceCollection services, IConfiguration configuration)
        {
            services.AddExceptionHandler<CustomExceptionHandler>();
            services.AddControllers();

            services.ConfigureJsonSerializer();

            ConfigureAuthentication(services, configuration);

            ConfigureAuthorizationPolicies(services);

            services.AddProblemDetails();
            services.AddHttpContextAccessor();

            services.ConfigureSignalR();

            AddScopedServices(services);

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

            return services;
        }

        private static void AddScopedServices(IServiceCollection services)
        {
            services.TryAddScoped<ICurrentUserService, CurrentUserService>();
            services.TryAddScoped<IFinancialChatNotifier, FinancialChatNotifier>();
        }

        private static void ConfigureAuthentication(IServiceCollection services, IConfiguration configuration)
        {
            services.Configure<JwtSettings>(configuration.GetSection(JwtSettings.Jwt));
            services.Configure<AuthenticationOptions>(configuration.GetSection(AuthenticationOptions.Authentication));
            var jwtSettings = configuration.GetSection(JwtSettings.Jwt).Get<JwtSettings>()
                ?? throw new InvalidOperationException("Jwt Settings not configured");
            var authOptions = configuration.GetSection(AuthenticationOptions.Authentication).Get<AuthenticationOptions>()
                ?? throw new InvalidOperationException("Authentication options not configured");

            services.AddAuthentication(options =>
            {
                options.DefaultScheme = AuthenticationSchemes.MultiScheme;
                options.DefaultAuthenticateScheme = AuthenticationSchemes.MultiScheme;
                options.DefaultChallengeScheme = AuthenticationSchemes.MultiScheme;

                options.DefaultSignInScheme = IdentityConstants.ApplicationScheme;
                options.DefaultSignOutScheme = IdentityConstants.ApplicationScheme;
            })
                .AddCookie(IdentityConstants.ApplicationScheme, o =>
                {
                    o.LoginPath = new PathString("/api/v1/auth/login");
                    o.Events.OnRedirectToLogin = (context) =>
                    {
                        context.Response.StatusCode = StatusCodes.Status401Unauthorized;
                        return Task.CompletedTask;
                    };
                    o.Cookie.HttpOnly = true;
                    o.Cookie.SecurePolicy = CookieSecurePolicy.Always;
                    o.Cookie.SameSite = SameSiteMode.Lax;
                })
                .AddCookie(IdentityConstants.ExternalScheme, o =>
                {
                    o.Cookie.Name = "Identity.External";
                    o.Cookie.HttpOnly = true;
                    o.Cookie.SecurePolicy = CookieSecurePolicy.Always;
                    o.Cookie.SameSite = SameSiteMode.Lax;
                    o.ExpireTimeSpan = TimeSpan.FromMinutes(15);
                })
                .AddPolicyScheme(AuthenticationSchemes.MultiScheme, "JWT or API Key", options =>
                {
                    options.ForwardDefaultSelector = context =>
                    {
                        if (context.Request.Headers.ContainsKey(CustomHeaders.ApiKey) ||
                        context.Request.Query.ContainsKey(QueryStringParameters.ApiKey))
                        {
                            return ApiKeyAuthenticationOptions.DefaultScheme;
                        }

                        return JwtBearerDefaults.AuthenticationScheme;
                    };
                })
                .AddJwtBearer(options =>
                {
                    options.SaveToken = true;
                    options.RequireHttpsMetadata = false;
                    options.TokenValidationParameters = new TokenValidationParameters
                    {
                        ValidateIssuer = true,
                        ValidateAudience = true,
                        ValidateLifetime = true,
                        ValidateIssuerSigningKey = true,
                        ValidIssuer = jwtSettings.Issuer,
                        ValidAudience = jwtSettings.Audience,
                        IssuerSigningKey = new SymmetricSecurityKey(Encoding.UTF8.GetBytes(jwtSettings.SecretKey)),
                        ClockSkew = TimeSpan.Zero,
                    };

                    // Configure SignalR authentication
                    options.Events = new JwtBearerEvents
                    {
                        OnMessageReceived = context =>
                        {
                            var accessToken = context.Request.Query[QueryStringParameters.AccessToken];
                            var path = context.HttpContext.Request.Path;

                            if (!string.IsNullOrEmpty(accessToken) &&
                                path.StartsWithSegments("/hubs/finance"))
                            {
                                context.Token = accessToken;
                            }
                            return Task.CompletedTask;
                        }
                    };
                })
                .AddApiKeyAuthentication(options =>
                {
                    options.AuthorizationHeaderName = CustomHeaders.ApiKey;
                    options.QueryStringParameterName = QueryStringParameters.ApiKey;
                })
                .AddGoogle(gOpt =>
                {
                    gOpt.ClientId = authOptions.Google.ClientId;
                    gOpt.ClientSecret = authOptions.Google.ClientSecret;
                    gOpt.SignInScheme = IdentityConstants.ExternalScheme;
                });
        }

        private static void ConfigureAuthorizationPolicies(IServiceCollection services)
        {
            services.AddAuthorizationBuilder()

                .AddPolicy(Policies.CanPurge, policy => policy.RequireRole(Roles.Administrator))

                .AddPolicy(Policies.UserAccess, policy =>
                    policy.RequireAuthenticatedUser()
                        .AddAuthenticationSchemes(JwtBearerDefaults.AuthenticationScheme))

                .AddPolicy(Policies.FrontendAccess, policy =>
                    policy.RequireAuthenticatedUser()
                        .AddAuthenticationSchemes(ApiKeyAuthenticationOptions.DefaultScheme)
                        .RequireClaim("scope", "frontend:full"))

                .AddPolicy(Policies.AiServiceAccess, policy =>
                    policy.RequireAuthenticatedUser()
                        .AddAuthenticationSchemes(ApiKeyAuthenticationOptions.DefaultScheme)
                        .RequireClaim("scope", "ai:analyze"))

                .AddPolicy(Policies.DispatcherServiceAccess, policy =>
                    policy.RequireAuthenticatedUser()
                        .AddAuthenticationSchemes(ApiKeyAuthenticationOptions.DefaultScheme)
                        .RequireClaim("scope", "dispatcher:full"))

                .AddPolicy(Policies.AdminAccess, policy =>
                    policy.RequireAuthenticatedUser()
                        .AddAuthenticationSchemes(AuthenticationSchemes.MultiScheme)
                        .RequireAssertion(context =>
                            context.User.HasClaim(c => c.Type == ClaimTypes.Role && c.Value == Roles.Administrator) ||
                            context.User.HasClaim(c => c.Type == "scope" && c.Value == "admin:access")));
        }

        private static void AddSwaggerService(IServiceCollection services)
        {
            services.AddEndpointsApiExplorer();
            services.AddSwaggerGen(options =>
            {
                options.SwaggerDoc("v1", new OpenApiInfo { Title = "EMS", Version = "1.0" });

                options.AddSecurityDefinition("Bearer", new OpenApiSecurityScheme
                {
                    Description = "JWT Authorization header using the Bearer scheme. Example: \"Authorization: Bearer {token}\"",
                    Name = "Authorization",
                    Scheme = "Bearer",
                    In = ParameterLocation.Header,
                    Type = SecuritySchemeType.Http,
                    BearerFormat = "JWT",
                });

                options.AddSecurityDefinition("ApiKey", new()
                {
                    Description = "API Key authentication. Example: \"X-API-Key: {key}\"",
                    Name = CustomHeaders.ApiKey,
                    In = ParameterLocation.Header,
                    Type = SecuritySchemeType.ApiKey,
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
                    },
                    {
                        new OpenApiSecurityScheme
                        {
                            Reference = new OpenApiReference
                            {
                                Type = ReferenceType.SecurityScheme,
                                Id = "ApiKey",
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
