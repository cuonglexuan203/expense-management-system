﻿using EMS.API.Hubs;
using EMS.Application;
using EMS.Infrastructure;
using Serilog;

namespace EMS.API
{
    public class Startup
    {
        private IConfiguration _configuration;
        public Startup(IConfiguration configuration)
        {
            _configuration = configuration;
        }

        public void ConfigureServices(IServiceCollection services)
        {
            #region Adding layers
            services.AddApplicationServices();
            services.AddInfrastructureServices(_configuration);
            services.AddApiServices(_configuration);
            #endregion
        }

        public void Configure(IApplicationBuilder app, IWebHostEnvironment env)
        {
            if (env.IsDevelopment())
            {
                app.UseDeveloperExceptionPage();
                app.UseSwagger();
                app.UseSwaggerUI(options =>
                {
                    options.SwaggerEndpoint("/swagger/v1/swagger.json", "EMS.API v1");
                    options.DisplayRequestDuration();
                });
            }

            app.UseSerilogRequestLogging();
            app.UseCors("anonymous_policy");
            app.UseExceptionHandler();
            app.UseHttpsRedirection();
            app.UseAuthentication();
            app.UseRouting();
            app.UseAuthorization();
            app.UseStaticFiles();
            app.UseEndpoints(endpoints =>
            {
                endpoints.MapControllers();
                endpoints.MapHub<FinancialChatHub>("/hubs/finance");
            });
        }
    }
}
