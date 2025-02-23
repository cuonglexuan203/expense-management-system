using EMS.Application.Common.Exceptions;
using Microsoft.AspNetCore.Diagnostics;
using Microsoft.AspNetCore.Mvc;

namespace EMS.API.Common.Middleware
{
    public class CustomExceptionHandler : IExceptionHandler
    {
        public CustomExceptionHandler()
        {

        }
        public async ValueTask<bool> TryHandleAsync(HttpContext httpContext, Exception exception, CancellationToken cancellationToken)
         => exception switch
         {
             ValidationException ex => await HandleValidationException(httpContext, ex),
             BadRequestException ex => await HandleBadRequestException(httpContext, ex),
             NotFoundException ex => await HandleNotFoundException(httpContext, ex),
             UnauthorizedAccessException ex => await HandleUnauthorizedAccessException(httpContext, ex),
             ForbiddenAccessException ex => await HandleForbiddenAccessException(httpContext, ex),
             _ => false
         };

        private async Task<bool> HandleForbiddenAccessException(HttpContext httpContext, ForbiddenAccessException ex)
        {
            httpContext.Response.StatusCode = StatusCodes.Status403Forbidden;
            var problemDetails = new ProblemDetails
            {
                Title = "Forbidden",
                Status = StatusCodes.Status403Forbidden,
                Type = "https://tools.ietf.org/html/rfc7231#section-6.5.3"
            };

            await httpContext.Response.WriteAsJsonAsync(problemDetails).ConfigureAwait(false);

            return true;
        }

        private async Task<bool> HandleUnauthorizedAccessException(HttpContext httpContext, UnauthorizedAccessException ex)
        {
            httpContext.Response.StatusCode = StatusCodes.Status401Unauthorized;
            var problemDetails = new ProblemDetails
            {
                Title = "Unauthorized",
                Status = StatusCodes.Status401Unauthorized,
                Type = "https://tools.ietf.org/html/rfc7235#section-3.1"
            };

            await httpContext.Response.WriteAsJsonAsync(problemDetails).ConfigureAwait(false);

            return true;
        }

        private async Task<bool> HandleNotFoundException(HttpContext httpContext, NotFoundException ex)
        {
            httpContext.Response.StatusCode = StatusCodes.Status404NotFound;
            var problemDetails = new ProblemDetails
            {
                Title = "The specified resource was not found.",
                Status = StatusCodes.Status404NotFound,
                Type = "https://tools.ietf.org/html/rfc7231#section-6.5.4",
                Detail = ex.Message
            };

            await httpContext.Response.WriteAsJsonAsync(problemDetails).ConfigureAwait(false);

            return true;
        }

        private async Task<bool> HandleBadRequestException(HttpContext httpContext, BadRequestException ex)
        {
            httpContext.Response.StatusCode = StatusCodes.Status400BadRequest;
            var problemDetails = new ProblemDetails
            {
                Title = "Bad Request",
                Status = StatusCodes.Status400BadRequest,
                Type = "https://tools.ietf.org/html/rfc7231#section-6.5.1",
                Detail = ex.Message,
            };

            await httpContext.Response.WriteAsJsonAsync(problemDetails).ConfigureAwait(false);

            return true;
        }

        private async Task<bool> HandleValidationException(HttpContext httpContext, ValidationException ex)
        {
            httpContext.Response.StatusCode = StatusCodes.Status400BadRequest;
            var problemDetails = new ValidationProblemDetails(ex.Errors)
            {
                Status = StatusCodes.Status400BadRequest,
                Type = "https://tools.ietf.org/html/rfc7231#section-6.5.1"
            };

            await httpContext.Response.WriteAsJsonAsync(problemDetails).ConfigureAwait(false);

            return true;
        }
    }
}
