﻿using EMS.Application.Common.Exceptions;
using EMS.Core.Exceptions;
using Microsoft.AspNetCore.Diagnostics;
using Microsoft.AspNetCore.Mvc;
using Microsoft.IdentityModel.Tokens;

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
             SecurityTokenException ex => await HandleSecurityTokenException(httpContext, ex),
             ForbiddenAccessException ex => await HandleForbiddenAccessException(httpContext, ex),
             InvalidTransactionOperationException ex => await HandleInvalidTransactionOperationException(httpContext, ex),
             InvalidOperationException ex => await HandleInvalidOperationException(httpContext, ex),
             _ => false
         };

        private async Task<bool> HandleInvalidOperationException(HttpContext httpContext, InvalidOperationException ex)
        {
            httpContext.Response.StatusCode = StatusCodes.Status409Conflict;
            var problemDetails = new ProblemDetails
            {
                Title = "Invalid operation",
                Status = StatusCodes.Status409Conflict,
                Type = "https://datatracker.ietf.org/doc/html/rfc7231#section-6.5.8",
                Detail = ex.Message,
            };

            await httpContext.Response.WriteAsJsonAsync(problemDetails).ConfigureAwait(false);

            return true;
        }

        private async Task<bool> HandleInvalidTransactionOperationException(HttpContext httpContext, InvalidTransactionOperationException ex)
        {
            httpContext.Response.StatusCode = StatusCodes.Status409Conflict;
            var problemDetails = new ProblemDetails
            {
                Title = "Invalid transaction operation",
                Status = StatusCodes.Status409Conflict,
                Type = "https://datatracker.ietf.org/doc/html/rfc7231#section-6.5.8",
                Detail = ex.Message,
            };

            await httpContext.Response.WriteAsJsonAsync(problemDetails).ConfigureAwait(false);

            return true;
        }

        private async Task<bool> HandleForbiddenAccessException(HttpContext httpContext, ForbiddenAccessException ex)
        {
            httpContext.Response.StatusCode = StatusCodes.Status403Forbidden;
            var problemDetails = new ProblemDetails
            {
                Title = "Forbidden",
                Status = StatusCodes.Status403Forbidden,
                Type = "https://tools.ietf.org/html/rfc7231#section-6.5.3",
                Detail = ex.Message,
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
                Type = "https://tools.ietf.org/html/rfc7235#section-3.1",
            };

            await httpContext.Response.WriteAsJsonAsync(problemDetails).ConfigureAwait(false);

            return true;
        }

        private async Task<bool> HandleSecurityTokenException(HttpContext httpContext, SecurityTokenException ex)
        {
            httpContext.Response.StatusCode = StatusCodes.Status401Unauthorized;
            var problemDetails = new ProblemDetails
            {
                Title = "Invalid token",
                Status = StatusCodes.Status401Unauthorized,
                Type = "https://tools.ietf.org/html/rfc7235#section-3.1",
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
