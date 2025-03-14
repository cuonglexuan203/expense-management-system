using Asp.Versioning;
using Microsoft.AspNetCore.Mvc;

namespace EMS.API.Controllers.v1
{
    [ApiController]
    [ApiVersion("1.0")]
    public abstract class ApiControllerBase : ControllerBase
    {

    }
}
