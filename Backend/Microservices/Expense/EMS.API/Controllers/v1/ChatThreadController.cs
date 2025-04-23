using EMS.API.Common.Attributes;
using EMS.Application.Features.Chats.Queries.GetAllChatThreads;
using EMS.Application.Features.Chats.Queries.GetChatThreadById;
using EMS.Application.Features.Chats.Queries.GetMessages;
using EMS.Core.Specifications;
using MediatR;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace EMS.API.Controllers.v1
{
    [Authorize]
    [ApiRoute("chat-threads")]
    public class ChatThreadController : ApiControllerBase
    {
        private readonly ISender _sender;

        public ChatThreadController(ISender sender)
        {
            _sender = sender;
        }

        [HttpGet]
        public async Task<IActionResult> GetAllChatThreads()
        {
            var result = await _sender.Send(new GetAllChatThreadsQuery());

            return Ok(result);
        }

        [HttpGet("{id}")]
        public async Task<IActionResult> GetChatThreadById(int id)
        {
            var result = await _sender.Send(new GetChatThreadByIdQuery(id));

            return Ok(result);
        }

        [HttpGet("{id}/messages")]
        public async Task<IActionResult> GetMessages(int id, [FromQuery] ChatMessageSpecParams specParams)
        {
            var result = await _sender.Send(new GetMessagesQuery(id, specParams));

            return Ok(result);
        }
    }
}
