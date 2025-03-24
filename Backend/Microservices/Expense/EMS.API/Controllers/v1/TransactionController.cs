using EMS.API.Common.Attributes;
using EMS.Application.Features.Chats.Finance.Commands.ConfirmExtractedTransaction;
using EMS.Application.Features.Transactions.Commands.CreateTransaction;
using EMS.Application.Features.Transactions.Queries.GetTransactionById;
using EMS.Application.Features.Transactions.Queries.GetTransactions;
using EMS.Core.Specifications;
using MediatR;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace EMS.API.Controllers.v1
{
    [Authorize]
    [ApiRoute("transactions")]
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
            var result = await _sender.Send(new GetTransactionByIdQuery(id));

            return Ok(result);
        }

        [HttpGet]
        public async Task<IActionResult> GetTransactions([FromQuery] TransactionSpecParams specParams)
        {
            var result = await _sender.Send(new GetTransactionsQuery(specParams));

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
