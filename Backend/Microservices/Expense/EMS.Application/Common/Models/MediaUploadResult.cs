namespace EMS.Application.Common.Models
{
    public class MediaUploadResult
    {
        public bool Success { get; set; }
        public string? Url { get; set; }
        public string? SecureUrl { get; set; }
        public string? ThumbnailUrl { get; set; }
        public string? PublicId { get; set; }
        public string? AssetId { get; set; }
        public string? Format { get; set; }
        public string Version { get; set; } = default!;
        public long Size { get; set; }
        public string? ResourceType { get; set; }
        public string? Error { get; set; }
        public Dictionary<string, object>? Metadata { get; set; }
    }
}
