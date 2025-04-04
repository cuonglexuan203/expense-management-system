using EMS.API.Common.Attributes;
using EMS.Application.Common.DTOs;
using EMS.Application.Features.Auth.Commands.CreateApiKey;
using EMS.Application.Features.Auth.Commands.RevokeApiKey;
using EMS.Application.Features.Auth.Queries.GetApiKeyById;
using EMS.Application.Features.Auth.Queries.GetApiKeys;
using EMS.Core.Constants;
using MediatR;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace EMS.API.Controllers.v1
{
    [ApiRoute("api-keys")]
    [Authorize(Policy = Policies.AdminAccess)]
    public class ApiKeyController : ApiControllerBase
    {
        private readonly ISender _sender;

        public ApiKeyController(ISender sender)
        {
            _sender = sender;
        }

        [HttpPost]
        public async Task<IActionResult> CreateApiKey(ApiKeyCreationDto apiKeyCreationDto)
        {
            var result = await _sender.Send(new CreateApiKeyCommand(apiKeyCreationDto));

            return Ok(result);
        }

        [HttpGet("{id}")]
        public async Task<IActionResult> GetApiKey(Guid id)
        {
            var result = await _sender.Send(new GetApiKeyByIdQuery(id));

            return Ok(result);
        }

        [HttpGet]
        public async Task<IActionResult> GetApiKeys()
        {
            var result = await _sender.Send(new GetApiKeysQuery());

            return Ok(result);
        }

        [HttpPost("{id}/revoke")]
        public async Task<IActionResult> RevokeApiKey(Guid id)
        {
            var result = await _sender.Send(new RevokeApiKeyCommand(id));

            if (!result)
            {
                return NotFound();
            }

            return Ok(result);
        }
    }
}
