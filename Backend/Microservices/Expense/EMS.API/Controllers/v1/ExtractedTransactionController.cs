using EMS.API.Common.Attributes;
using EMS.API.Common.Models.ExtractedTransactionController;
using EMS.Application.Features.Chats.Finance.Commands.ConfirmExtractedTransaction;
using MediatR;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace EMS.API.Controllers.v1
{
    [Authorize]
    [ApiRoute("extracted-transactions")]
    public class ExtractedTransactionController : ApiControllerBase
    {
        private readonly ISender _sender;

        public ExtractedTransactionController(ISender sender)
        {
            _sender = sender;
        }

        [HttpPost("{id}/confirm")]
        public async Task<IActionResult> ConfirmExtractedTransaction(int id, ConfirmExtractedTransactionRequest request)
        {
            var result = await _sender.Send(new ConfirmExtractedTransactionCommand(id, request.WalletId));

            return Ok(result);
        }
    }
}
