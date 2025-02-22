using EMS.Core.Entities.Common;
using EMS.Core.Enums;

namespace EMS.Core.Entities
{
    public class Media : BaseAuditableEntity<Guid>
    {
        public string FileName { get; set; } = default!;
        public string? ContentType { get; set; } // MIME
        public string Url { get; set; } = default!;
        public int Size { get; set; }
        public string Extension { get; set; } = default!;
        public MediaType Type { get; set; }
        public string? AltText { get; set; }
        public string? Caption { get; set; }
        public string? Metadata { get; set; }
        public int? ChatMessageId { get; set; }

        // Navigations
        public ChatMessage? ChatMessage { get; set; }
    }
}
