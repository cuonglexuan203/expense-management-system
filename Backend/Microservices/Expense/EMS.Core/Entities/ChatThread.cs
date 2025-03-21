using EMS.Core.Entities.Common;

namespace EMS.Core.Entities
{
    public class ChatThread: BaseAuditableEntity<int>
    {
        public string UserId { get; set; } = default!;
        public string Title { get; set; } = default!;
        public bool IsActive { get; set; } = true;

        // Navigations
        public ICollection<ChatMessage> ChatMessages { get; set; } = [];
    }
}
