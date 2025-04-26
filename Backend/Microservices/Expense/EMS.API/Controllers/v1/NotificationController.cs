using EMS.API.Common.Attributes;
using EMS.Application.Features.Notifications.Commands.AnalyzeNotification;
using EMS.Application.Features.Notifications.Queries.GetNotifications;
using EMS.Core.Specifications;
using MediatR;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace EMS.API.Controllers.v1
{
    [Authorize]
    [ApiRoute("notifications")]
    public class NotificationController : ApiControllerBase
    {
        private readonly ISender _sender;

        public NotificationController(ISender sender)
        {
            _sender = sender;
        }

        [HttpPost("analyze")]
        public async Task<IActionResult> AnalyzeNotification(AnalyzeNotificationCommand command)
        {
            var result = await _sender.Send(command);

            return Ok(result);
        }

        [HttpGet]
        public async Task<IActionResult> GetNotifications([FromQuery] NotificationSpecParams specParams)
        {
            var result = await _sender.Send(new GetNotificationsQuery(specParams));

            return Ok(result);
        }
    }
}
