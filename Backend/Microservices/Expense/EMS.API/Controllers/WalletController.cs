using EMS.Application.Features.Wallet.Commands.CreateWallet;
using EMS.Application.Features.Wallet.Commands.UpdateWallet;
using EMS.Application.Features.Wallet.Dtos;
using EMS.Application.Features.Wallet.Queries;
using MediatR;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace EMS.API.Controllers
{
    [Authorize]
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

        [HttpPost("wallet-summary")]
        public async Task<IActionResult> GetWalletSummary(GetWalletSummaryQuery query)
        {
            var result = await _sender.Send(query);

            return Ok(result);
        }
    }
}