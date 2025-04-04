using EMS.API.Common.Attributes;
using EMS.Application.Features.CurrencySlangs.Queries.GetCurrencySlangs;
using EMS.Core.Constants;
using EMS.Core.Enums;
using MediatR;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace EMS.API.Controllers.v1
{
    [ApiRoute("currency-slangs")]
    public class CurrencySlangController : ApiControllerBase
    {
        private readonly ISender _sender;

        public CurrencySlangController(ISender sender)
        {
            _sender = sender;
        }

        [Authorize(Policy = Policies.AiServiceAccess)]
        [HttpGet("{currencyCode}")]
        public async Task<IActionResult> GetCurrencySlangs(CurrencyCode currencyCode)
        {
            var result = await _sender.Send(new GetCurrencySlangsQuery(currencyCode));

            return Ok(result);
        }
    }
}
