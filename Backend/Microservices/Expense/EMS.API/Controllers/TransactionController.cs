using EMS.Application.Features.Transactions.Commands.CreateTransaction;
using EMS.Application.Features.Transactions.Queries.GetTransaction;
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

        [HttpGet("{id:int}")]
        public async Task<IActionResult> GetTransaction(int id)
        {
            var result = await _sender.Send(new GetTransactionQuery(id));

            return Ok(result);
        }

        [HttpPost]
        public async Task<IActionResult> CreateTransaction(CreateTransactionCommand command)
        {
            var result = await _sender.Send(command);

            return Ok(result);
        }
    }
}
