using EMS.Application.Common.Mappings;
using EMS.Core.Entities;
using EMS.Core.Enums;

namespace EMS.Application.Common.DTOs
{
    public class MediaDto : IMapFrom<Media>
    {
        public Guid Id { get; set; }
        public string Url { get; set; } = default!;
        public string? SecureUrl { get; set; }
        public string? ThumbnailUrl { get; set; }
        public long Size { get; set; }
        public string Extension { get; set; } = default!;
        public FileType Type { get; set; }
        public string? PublicId { get; set; }
        public string? AssetId { get; set; }
        public string? AltText { get; set; }
        public string? Caption { get; set; }

        // Dimension
        public int? Width { get; set; }
        public int? Height { get; set; }
        public int? Duration { get; set; }

        // Tracking
        public MediaStatus Status { get; set; }
        public string? Metadata { get; set; }
        public bool IsOptimized { get; set; }

        public int? ChatMessageId { get; set; }

        public DateTimeOffset? CreatedAt { get; set; }
    }
}
