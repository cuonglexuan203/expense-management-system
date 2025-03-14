using Microsoft.AspNetCore.Mvc;
using System.Diagnostics.CodeAnalysis;

namespace EMS.API.Common.Attributes
{
    public class ApiRouteAttribute : RouteAttribute
    {
        public ApiRouteAttribute([StringSyntax("Route")] string template) 
            : base($"api/v{{version:apiVersion}}/{template}")
        {

        }
    }
}
