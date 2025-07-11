﻿using EMS.API.Common.Attributes;
using EMS.Application.Features.Developer.Queries;
using MediatR;
using Microsoft.AspNetCore.Mvc;

namespace EMS.API.Controllers.v1
{
    [ApiRoute("developer")]
    public class DeveloperController : ApiControllerBase
    {
        private readonly ISender _sender;

        public DeveloperController(ISender sender)
        {
            _sender = sender;
        }

        [HttpGet("ping")]
        public IActionResult Ping()
        {
            return Ok(new { Message = "Pong"});
        }

        [HttpGet("system-settings")]
        public async Task<IActionResult> GetSystemSettings()
        {
            var result = await _sender.Send(new GetSystemSettingsQuery());

            return Ok(result);
        }
    }
}
