using EMS.API.Common.Attributes;
using EMS.Application.Common.Interfaces.Services;
using EMS.Application.Features.Preferences.Queries.GetUserPreferences;
using MediatR;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace EMS.API.Controllers.v1
{
    [Authorize]
    [ApiRoute("user-preferences")]
    public class UserPreferenceController : ApiControllerBase
    {
        private readonly ISender _sender;
        private readonly ICurrentUserService _currentUserService;

        public UserPreferenceController(
            ISender sender,
            ICurrentUserService currentUserService)
        {
            _sender = sender;
            _currentUserService = currentUserService;
        }

        [HttpGet("{userId}")]
        public async Task<IActionResult> GetUserPreferences(string userId)
        {
            if(userId != _currentUserService.Id)
            {
                return BadRequest();
            }

            var result = await _sender.Send(new GetUserPreferencesQuery());

            return Ok(result);
        }
    }
}
