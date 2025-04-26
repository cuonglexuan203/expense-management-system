using EMS.API.Common.Attributes;
using EMS.Application.Features.ExtractedTransactions.Commands.UploadMessageFiles;
using MediatR;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace EMS.API.Controllers.v1
{
    [Authorize]
    [ApiRoute("medias")]
    public class MediaController : ApiControllerBase
    {
        private readonly ISender _sender;

        public MediaController(ISender sender)
        {
            _sender = sender;
        }

        [HttpPost("messages/{messageId}")]
        public async Task<IActionResult> UploadMessageFiles(int messageId, [FromForm] List<IFormFile> files, [FromForm] int walletId)
        {
            if (files == null || files.Count == 0)
                return BadRequest("No files were provided");

            var command = new UploadMessageFilesCommand
            {
                MessageId = messageId,
                WalletId = walletId,
            };

            foreach (var file in files)
            {
                command.Files.Add(new()
                {
                    FileStream = file.OpenReadStream(),
                    FileName = file.FileName,
                    ContentType = file.ContentType
                });
            }

            var result = await _sender.Send(command);

            return Ok(result);
        }
    }
}
