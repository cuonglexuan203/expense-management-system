using EMS.API.Common.Attributes;
using EMS.Application.Features.DeviceTokens.Commands.AddDeviceToken;
using EMS.Application.Features.DeviceTokens.Queries.GetActiveDeviceTokens;
using EMS.Core.Constants;
using MediatR;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace EMS.API.Controllers.v1
{
    [ApiRoute("device-tokens")]
    public class DeviceTokenController : ApiControllerBase
    {
        private readonly ISender _sender;

        public DeviceTokenController(ISender sender)
        {
            _sender = sender;
        }

        [Authorize]
        [HttpPost]
        public async Task<IActionResult> AddDeviceToken(AddDeviceTokenCommand command)
        {
            var result = await _sender.Send(command);

            return Ok(result);
        }

        [Authorize(Policy = Policies.DispatcherServiceAccess)]
        [HttpGet("users/{userId}")]
        public async Task<IActionResult> GetDeviceTokens(string userId)
        {
            var result = await _sender.Send(new GetActiveDeviceTokensQuery(userId));

            return Ok(result);
        }
    }
}
