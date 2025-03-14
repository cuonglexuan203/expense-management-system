using EMS.API.Common.Attributes;
using EMS.Application.Features.Wallets.Commands.CreateWallet;
using EMS.Application.Features.Wallets.Commands.UpdateWallet;
using EMS.Application.Features.Wallets.Dtos;
using EMS.Application.Features.Wallets.Queries.GetWalletsByUser;
using EMS.Application.Features.Wallets.Queries.GetWalletSummary;
using MediatR;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace EMS.API.Controllers.v1
{
    [Authorize]
    [ApiRoute("wallets")]
    public class WalletController : ApiControllerBase
    {
        private readonly ISender _sender;

        public WalletController(ISender sender)
        {
            _sender = sender;
        }

        [HttpPost]
        public async Task<ActionResult<WalletDto>> Create(CreateWalletCommand command)
        {
            return await _sender.Send(command);
        }

        [HttpPut("{id}")]
        public async Task<ActionResult<WalletDto>> Update(int id, UpdateWalletCommand command)
        {
            if (id != command.Id)
            {
                return BadRequest();
            }

            return await _sender.Send(command);
        }

        [HttpGet]
        public async Task<IActionResult> GetWalletsByUser()
        {
            var result = await _sender.Send(new GetWalletsByUserQuery());

            return Ok(result);
        }

        [HttpPost("wallet-summary")]
        public async Task<IActionResult> GetWalletSummary(GetWalletSummaryQuery query)
        {
            var result = await _sender.Send(query);

            return Ok(result);
        }
    }
}