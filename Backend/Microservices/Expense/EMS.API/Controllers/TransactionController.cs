using EMS.Application.Features.Transactions.Commands.CreateTransaction;
using MediatR;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace EMS.API.Controllers
{
    [Authorize]
    public class TransactionController : ApiControllerBase
    {
        private readonly ISender _sender;

        public TransactionController(ISender sender)
        {
            _sender = sender;
        }

        [HttpPost]
        public async Task<IActionResult> CreateTransaction(CreateTransactionCommand command)
        {
            var result = await _sender.Send(command);

            return Ok(result);
        }

    }
}
