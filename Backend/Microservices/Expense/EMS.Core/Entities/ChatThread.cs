using EMS.Core.Entities.Common;
using EMS.Core.Enums;

namespace EMS.Core.Entities
{
    public class ChatThread: BaseAuditableEntity<int>
    {
        public string UserId { get; set; } = default!;
        public string Title { get; set; } = default!;
        public bool IsActive { get; set; } = true;
        public ChatThreadType Type { get; set; }

        // Navigations
        public ICollection<ChatMessage> ChatMessages { get; set; } = [];
    }
}
