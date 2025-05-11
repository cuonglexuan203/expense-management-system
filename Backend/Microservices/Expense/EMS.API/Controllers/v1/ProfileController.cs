using EMS.API.Common.Attributes;
using EMS.Application.Common.Exceptions;
using EMS.Application.Common.Interfaces.Services;
using EMS.Application.Features.Profiles.Commands.UpdateProfile;
using EMS.Application.Features.Profiles.Queries;
using MediatR;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace EMS.API.Controllers.v1
{
    [Authorize]
    [ApiRoute("profiles")]
    public class ProfileController : ApiControllerBase
    {
        private readonly ISender _sender;
        private readonly ICurrentUserService _user;

        public ProfileController(
            ISender sender,
            ICurrentUserService user)
        {
            _sender = sender;
            _user = user;
        }

        [HttpGet("{userId}")]
        public async Task<IActionResult> GetProfile(string userId)
        {
            if (userId != _user.Id)
            {
                throw new BadRequestException("Invalid user ID");
            }

            var result = await _sender.Send(new GetProfileQuery());

            return Ok(result);
        }

        [HttpPatch("{userId}")]
        public async Task<IActionResult> UpdateProfile(string userId, UpdateProfileCommand command)
        {
            if (userId != _user.Id)
            {
                throw new BadRequestException("Invalid user ID");
            }

            var result = await _sender.Send(command);

            return Ok(result);
        }
    }
}
