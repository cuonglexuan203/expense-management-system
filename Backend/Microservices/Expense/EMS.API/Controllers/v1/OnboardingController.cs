using EMS.API.Common.Attributes;
using EMS.Application.Features.Onboarding.Commands;
using EMS.Application.Features.Onboarding.Queries.GetCurrencies;
using EMS.Application.Features.Onboarding.Queries.GetLanguageCodes;
using EMS.Application.Features.Onboarding.Queries.GetOnboardingStatus;
using MediatR;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace EMS.API.Controllers.v1
{
    [Authorize]
    [ApiRoute("onboarding")]
    public class OnboardingController : ApiControllerBase
    {
        private readonly ISender _sender;

        public OnboardingController(ISender sender)
        {
            _sender = sender;
        }

        [HttpGet("languages")]
        public async Task<IActionResult> GetLanguages()
        {
            var result = await _sender.Send(new GetLanguagesQuery());

            return Ok(result);
        }

        [HttpGet("currencies")]
        public async Task<IActionResult> GetCurrencies()
        {
            var result = await _sender.Send(new GetCurrenciesQuery());

            return Ok(result);
        }

        [HttpGet("status")]
        public async Task<IActionResult> IsOnboardingCompleted()
        {
            var result = await _sender.Send(new GetOnboardingStatusQuery());

            return Ok(result);
        }

        [HttpPost]
        public async Task<IActionResult> CompleteUserOnboarding(CompleteUserOnboardingCommand command)
        {
            var result = await _sender.Send(command);

            return Ok(result);
        }
    }
}
