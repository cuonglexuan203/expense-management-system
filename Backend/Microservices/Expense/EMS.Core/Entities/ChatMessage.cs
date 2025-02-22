using EMS.Core.Entities.Common;
using EMS.Core.Enums;

namespace EMS.Core.Entities
{
    public class ChatMessage: BaseAuditableEntity<int>
    {
        public int ChatThreadId { get; set; }
        public string UserId { get; set; } = default!;
        public MessageRole Role { get; set; } = MessageRole.User;
        public string? Content { get; set; }
        public string? DetectedItems { get; set; }
        public bool RequiresConfirmation { get; set; }
        public bool UserConfirmation { get; set; }
        public string? Metadata { get; set; }

        // Navigations
        public ChatThread ChatThread { get; set; } = default!;
        public ICollection<Media> Medias { get; set; } = [];
        public Transaction? Transaction { get; set; }
    }
}
