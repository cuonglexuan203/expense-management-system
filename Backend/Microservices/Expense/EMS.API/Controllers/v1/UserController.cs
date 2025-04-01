using EMS.API.Common.Attributes;
using EMS.Application.Common.Interfaces.Services;
using EMS.Application.Features.Preferences.Queries.GetUserPreferences;
using MediatR;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace EMS.API.Controllers.v1
{
    [Authorize]
    [ApiRoute("users")]
    public class UserController : ApiControllerBase
    {
        private readonly ISender _sender;
        private readonly ICurrentUserService _currentUserService;

        public UserController(
            ISender sender,
            ICurrentUserService currentUserService)
        {
            _sender = sender;
            _currentUserService = currentUserService;
        }

        [HttpGet("{userId}/preferences")]
        public async Task<IActionResult> GetUserPreferences(string userId)
        {
            if (userId != _currentUserService.Id)
            {
                return BadRequest();
            }

            var result = await _sender.Send(new GetUserPreferencesQuery());

            return Ok(result);
        }
    }
}
