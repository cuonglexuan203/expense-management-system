using EMS.API.Common.Attributes;
using EMS.API.Common.Models.PreferenceController;
using EMS.Application.Features.Preferences.Commands;
using EMS.Application.Features.Preferences.Queries.GetUserPreferences;
using MediatR;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace EMS.API.Controllers.v1
{
    [Authorize]
    [ApiRoute("preferences")]
    public class PreferenceController : ApiControllerBase
    {
        private readonly ISender _sender;

        public PreferenceController(ISender sender)
        {
            _sender = sender;
        }

        [HttpGet]
        public async Task<IActionResult> GetUserPreferences()
        {
            var result = await _sender.Send(new GetUserPreferencesQuery());

            return Ok(result);
        }

        [HttpPut("language")]
        public async Task<IActionResult> UpdateLanguage(UpdateLanguageRequest request)
        {
            var result = await _sender.Send(new UpdateLanguageCommand(request.LanguageCode));

            return Ok(result);
        }
    }
}
