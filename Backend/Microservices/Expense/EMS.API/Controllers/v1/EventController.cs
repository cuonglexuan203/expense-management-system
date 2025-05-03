using EMS.API.Common.Attributes;
using EMS.Application.Features.Events.Commands.ScheduleEvent;
using EMS.Application.Features.Events.Queries.GetEventOccurrences;
using EMS.Application.Features.Events.Queries.GetScheduledEvents;
using EMS.Core.Specifications;
using MediatR;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace EMS.API.Controllers.v1
{
    [Authorize]
    [ApiRoute("events")]
    public class EventController : ApiControllerBase
    {
        private readonly ISender _sender;

        public EventController(
            ISender sender)
        {
            _sender = sender;
        }

        [HttpPost]
        public async Task<IActionResult> ScheduleEvent(ScheduleEventCommand command)
        {
            var result = await _sender.Send(command);

            return Ok(result);
        }

        [HttpGet]
        public async Task<IActionResult> GetScheduledEvents([FromQuery] ScheduledEventSpecParams specParams)
        {
            var result = await _sender.Send(new GetScheduledEventsQuery(specParams));

            return Ok(result);
        }

        [HttpGet("occurrences")]
        public async Task<IActionResult> GetEventOccurrences([FromQuery] GetEventOccurrencesQuery query)
        {
            var result = await _sender.Send(query);

            return Ok(result);
        }
    }
}
