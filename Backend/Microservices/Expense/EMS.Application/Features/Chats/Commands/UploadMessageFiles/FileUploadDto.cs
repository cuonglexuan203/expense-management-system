namespace EMS.Application.Features.ExtractedTransactions.Commands.UploadMessageFiles
{
    public class FileUploadDto : IDisposable
    {
        public string FileName { get; set; } = default!;
        public string ContentType { get; set; } = default!;
        public Stream FileStream { get; set; } = default!;

        public void Dispose()
        {
            FileStream?.Dispose();
        }
    }
}
