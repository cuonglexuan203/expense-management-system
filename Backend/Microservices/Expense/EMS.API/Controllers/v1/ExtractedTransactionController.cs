using EMS.API.Common.Attributes;
using EMS.API.Common.Models.ExtractedTransactionController;
using EMS.Application.Features.ExtractedTransactions.Commands.ConfirmExtractedTransaction;
using EMS.Application.Features.ExtractedTransactions.Commands.RejectExtractedTransaction;
using EMS.Core.Enums;
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

        /// <summary>
        /// Confirms an extracted transaction.
        /// </summary>
        /// <param name="id">The ID of the transaction to confirm.</param>
        /// <param name="request">The confirmation request containing wallet information.</param>
        /// <returns>The result of the confirmation operation.</returns>
        /// <remarks>
        /// This endpoint is deprecated and will be removed in a future version.
        /// Please use the Patch /api/extracted-transactions/{id}/status endpoint instead, which supports
        /// both confirmation and rejection operations.
        /// </remarks>
        [Obsolete("This endpoint is maintained for backward compatibility. Use UpdateExtractedTransactionStatus instead.")]
        [HttpPost("{id}/confirm")]
        public async Task<IActionResult> ConfirmExtractedTransaction(int id, ConfirmExtractedTransactionRequest request)
        {
            var result = await _sender.Send(new ConfirmExtractedTransactionCommand(id, request.WalletId));

            return Ok(result);
        }

        [HttpPatch("{id}/status")]
        public async Task<IActionResult> UpdateExtractedTransactionStatus(int id, UpdateExtractedTransactionStatusRequest request)
        {
            // Confirm
            if(request.ConfirmationStatus == ConfirmationStatus.Confirmed)
            {
                var confirmationResult = await _sender.Send(new ConfirmExtractedTransactionCommand(id, request.WalletId));
                return Ok(confirmationResult);
            }

            // Reject
            if(request.ConfirmationStatus == ConfirmationStatus.Rejected)
            {
                await _sender.Send(new RejectExtractedTransactionCommand(id, request.WalletId));

                return NoContent();
            }

            return BadRequest();
        }
    }
}
