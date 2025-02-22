
using EMS.API.Common.Extensions;
using EMS.Infrastructure.Persistence.DbContext;

namespace EMS.API
{
    public class Program
    {
        public static async Task Main(string[] args)
        {
            try
            {
                var host = CreateHostBuilder(args)
                    .Build();
                host.MigrateDatabase<ApplicationDbContext>();

                await host.InitializeDatabaseAsync();

                await host.RunAsync();
            }
            catch (Exception ex)
            {

            }
        }

        private static IHostBuilder CreateHostBuilder(string[] args)
            => Host.CreateDefaultBuilder(args)
            .ConfigureWebHostDefaults(webBuilder =>
            {
                webBuilder.UseStartup<Startup>();
            });
    }
}
