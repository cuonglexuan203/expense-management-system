using EMS.Application.Common.Exceptions;
using EMS.Application.Common.Interfaces.DbContext;
using EMS.Application.Common.Interfaces.Messaging;
using EMS.Application.Common.Interfaces.Services;
using EMS.Application.Common.Utils;
using EMS.Application.Features.Chats.Finance.Messaging;
using EMS.Core.Entities;
using EMS.Core.Enums;
using MediatR;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Logging;

namespace EMS.Application.Features.Chats.Finance.Commands.UploadMessageFiles
{
    public class UploadMessageFilesCommand : IRequest<UploadMessageFilesVm>
    {
        public int WalletId { get; set; }
        public List<FileUploadDto> Files { get; set; } = [];
        public int MessageId { get; set; }
    }

    public class UploadMessageFilesCommandHandler : IRequestHandler<UploadMessageFilesCommand, UploadMessageFilesVm>
    {
        private readonly ILogger<UploadMessageFilesCommandHandler> _logger;
        private readonly IApplicationDbContext _context;
        private readonly IMediaService _mediaService;
        private readonly ICurrentUserService _currentUserService;
        private readonly IMessageQueue<QueryMessage> _messageQueue;

        public UploadMessageFilesCommandHandler(
            ILogger<UploadMessageFilesCommandHandler> logger,
            IApplicationDbContext context,
            IMediaService mediaService,
            ICurrentUserService currentUserService,
            IMessageQueue<QueryMessage> messageQueue)
        {
            _logger = logger;
            _context = context;
            _mediaService = mediaService;
            _currentUserService = currentUserService;
            _messageQueue = messageQueue;
        }
        public async Task<UploadMessageFilesVm> Handle(UploadMessageFilesCommand request, CancellationToken cancellationToken)
        {
            try
            {
                var userId = _currentUserService.Id!;

                var message = await _context.ChatMessages
                    .FirstOrDefaultAsync(e => e.Id == request.MessageId && e.UserId == userId && !e.IsDeleted)
                    ?? throw new NotFoundException($"Chat message with id {request.MessageId} not found.");

                _logger.LogInformation("Starting upload media files for message {MessageId}", request.MessageId);

                var uploadMessageFilesVm = new UploadMessageFilesVm
                {
                    FilesReceived = request.Files.Count,
                    FilesUploaded = 0,
                    Medias = []
                };

                MessageTypes messageTypes = MessageTypes.None;
                // OPTIMIZE: upload in parallel
                foreach (var file in request.Files)
                {
                    try
                    {
                        switch (FileUtil.GetFileType(file.ContentType))
                        {
                            case FileType.Image:
                                {
                                    messageTypes |= MessageTypes.Image;
                                    break;
                                }
                            case FileType.Video:
                                {
                                    messageTypes |= MessageTypes.Video;
                                    break;
                                }
                            case FileType.Audio:
                                {
                                    messageTypes |= MessageTypes.Audio;
                                    break;
                                }
                        }
                        var media = new Media { ChatMessageId = request.MessageId };
                        var mediaDto = await _mediaService.UploadMediaAsync(
                            media,
                            file.FileStream,
                            file.FileName,
                            file.ContentType);

                        uploadMessageFilesVm.Medias.Add(mediaDto);
                        uploadMessageFilesVm.FilesUploaded++;
                    }
                    catch (Exception ex)
                    {
                        _logger.LogError("Error during upload file {FileName} for message {MessageId}: {ErrorMessage}",
                            file.FileName,
                            request.MessageId,
                            ex.Message);
                    }
                }

                message.MessageTypes |= messageTypes;
                await _context.SaveChangesAsync();

                _logger.LogInformation("Finished upload files for message {MessageId}: {UploadedFile}/{ReceivedFile}",
                    request.MessageId,
                    uploadMessageFilesVm.FilesUploaded,
                    uploadMessageFilesVm.FilesReceived);

                await _messageQueue.EnqueueAsync(new(userId, request.WalletId, message.ChatThreadId, message.Id), cancellationToken);

                return uploadMessageFilesVm;
            }
            finally
            {
                foreach (var file in request.Files)
                {
                    file.Dispose();
                }
            }
        }
    }
}
