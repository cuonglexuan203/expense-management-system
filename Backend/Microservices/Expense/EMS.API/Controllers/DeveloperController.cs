using EMS.Application.Features.Developer.Queries;
using MediatR;
using Microsoft.AspNetCore.Mvc;

namespace EMS.API.Controllers
{
    public class DeveloperController : ApiControllerBase
    {
        private readonly ISender _sender;

        public DeveloperController(ISender sender)
        {
            _sender = sender;
        }

        [HttpGet("[action]")]
        public async Task<IActionResult> GetPiCoin()
        {
            return Ok(new { Message = "You get 10k PI coins", Coin = 10000 });
        }

        [HttpGet("[action]")]
        public async Task<IActionResult> GetSystemSettings()
        {
            var result = await _sender.Send(new GetSystemSettingsQuery());

            return Ok(result);
        }
    }
}
