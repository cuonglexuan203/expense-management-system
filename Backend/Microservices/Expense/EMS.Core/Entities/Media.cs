using EMS.Core.Entities.Common;
using EMS.Core.Enums;

namespace EMS.Core.Entities
{
    public class Media : BaseAuditableEntity<Guid>
    {
        public string FileName { get; set; } = default!;
        public string? ContentType { get; set; } // MIME
        public string? Url { get; set; } = default!;
        public string? SecureUrl { get; set; } = default!;
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
        public MediaStatus Status { get; set; } = MediaStatus.Pending;
        //public string? Provider { get; set; }
        //public string? StoragePath { get; set; }
        public string? Metadata { get; set; }
        public bool IsOptimized { get; set; } = false;

        public int? ChatMessageId { get; set; }

        // Navigations
        public ChatMessage? ChatMessage { get; set; }
        public ICollection<Category> Categories { get; set; } = [];
    }
}
