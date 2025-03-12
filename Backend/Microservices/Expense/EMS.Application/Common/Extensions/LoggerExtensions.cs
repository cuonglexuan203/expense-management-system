using EMS.Core.Constants;
using Microsoft.Extensions.Logging;

namespace EMS.Application.Common.Extensions
{
    public static class LoggerExtensions
    {
        public static void LogStateInfo(this ILogger logger, string state, string message)
        {
            logger.LogInformation(LogTemplates.AppStateChange, state, message);
        }

        public static void LogStateWarning(this ILogger logger, string state, string message)
        {
            logger.LogWarning(LogTemplates.AppStateChange, state, message);
        }
        public static void LogStateError(this ILogger logger, string state, string message, Exception? exception = null)
        {
            logger.LogError(exception, LogTemplates.AppStateChange, state, message);
        }
    }
}
