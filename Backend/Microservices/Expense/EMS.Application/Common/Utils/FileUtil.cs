using EMS.Core.Enums;

namespace EMS.Application.Common.Utils
{
    public static class FileUtil
    {
        public static FileType GetFileType(string contentType)
        {
            if (string.IsNullOrEmpty(contentType))
            {
                return FileType.Other;
            }

            contentType = contentType.ToLower();

            if (contentType.StartsWith("image/"))
                return FileType.Image;

            if (contentType.StartsWith("video/"))
                return FileType.Video;

            if (contentType.StartsWith("audio/"))
                return FileType.Audio;

            if (contentType.StartsWith("application/pdf") ||
            contentType.StartsWith("application/msword") ||
            contentType.StartsWith("application/vnd.openxmlformats-officedocument") ||
            contentType.StartsWith("text/"))
                return FileType.Document;

            return FileType.Other;
        }
    }
}
