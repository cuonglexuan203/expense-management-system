using EMS.Core.Entities.Common;
using EMS.Core.Enums;

namespace EMS.Core.Entities
{
    public class ChatMessage: BaseEntity<int>
    {
        public int ChatThreadId { get; set; }
        public Guid UserId { get; set; }
        public MessageRole Role { get; set; } = MessageRole.User;
        public string? Content { get; set; }
        public string? DetectedItems { get; set; }
        public bool RequiresConfirmation { get; set; }
        public bool UserConfirmation { get; set; }
        public string? Metadata { get; set; }

        // Navigations
        public ICollection<Media> Medias { get; set; } = [];
        public Transaction? Transaction { get; set; }
    }
}
