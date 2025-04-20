using EMS.API.Common.Attributes;
using EMS.Application.Features.DeviceTokens.Commands.AddDeviceToken;
using EMS.Application.Features.DeviceTokens.Queries;
using MediatR;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace EMS.API.Controllers.v1
{
    [Authorize]
    [ApiRoute("device-tokens")]
    public class DeviceTokenController : ApiControllerBase
    {
        private readonly ISender _sender;

        public DeviceTokenController(ISender sender)
        {
            _sender = sender;
        }

        [HttpPost]
        public async Task<IActionResult> AddDeviceToken(AddDeviceTokenCommand command)
        {
            var result = await _sender.Send(command);

            return Ok(result);
        }

        [HttpGet("users/{userId}")]
        public async Task<IActionResult> GetDeviceTokens(string userId)
        {
            var result = await _sender.Send(new GetDeviceTokensQuery(userId));

            return Ok(result);
        }
    }
}
