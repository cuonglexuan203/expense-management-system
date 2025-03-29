using EMS.Application.Common.DTOs;

namespace EMS.Application.Features.Chats.Finance.Commands.UploadMessageFiles
{
    public class UploadMessageFilesVm
    {
        public List<MediaDto> Medias { get; set; } = [];
        public int FilesReceived { get; set; }
        public int FilesUploaded { get; set; }
    }
}
