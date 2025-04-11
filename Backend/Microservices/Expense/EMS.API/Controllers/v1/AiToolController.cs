using EMS.API.Common.Attributes;
using EMS.Application.Features.AiTools.Queries.GetMessages;
using EMS.Application.Features.AiTools.Queries.GetTransactions;
using EMS.Application.Features.AiTools.Queries.GetWalletById;
using EMS.Application.Features.AiTools.Queries.GetWalletsByUserId;
using EMS.Core.Constants;
using EMS.Core.Specifications;
using MediatR;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace EMS.API.Controllers.v1
{
    [Authorize(Policy = Policies.AiServiceAccess)]
    [ApiRoute("ai-tools")]
    public class AiToolController : ApiControllerBase
    {
        private readonly ISender _sender;

        public AiToolController(
            ISender sender)
        {
            _sender = sender;
        }

        [HttpGet("users/{userId}/transactions")]
        public async Task<IActionResult> GetTransactions([FromQuery] TransactionSpecParams specParams, [FromRoute] string userId)
        {
            var result = await _sender.Send(new GetTransactionsQuery(userId, specParams));

            return Ok(result);
        }

        [HttpGet("users/{userId}/chat-threads/{chatThreadId}/messages")]
        public async Task<IActionResult> GetMessages([FromRoute] string userId, [FromRoute] int chatThreadId, [FromQuery] ChatMessageSpecParams specParams)
        {
            var result = await _sender.Send(new GetMessagesQuery(userId, chatThreadId, specParams));

            return Ok(result);
        }

        [HttpGet("users/{userId}/wallets")]
        public async Task<IActionResult> GetWallets([FromRoute] string userId)
        {
            var result = await _sender.Send(new GetWalletsByUserIdQuery(userId));

            return Ok(result);
        }

        [HttpGet("users/{userId}/wallets/{walletId}")]
        public async Task<IActionResult> GetWalletById([FromRoute] string userId, [FromRoute] int walletId)
        {
            var result = await _sender.Send(new GetWalletByIdQuery(walletId));

            return Ok(result);
        }
    }
}
