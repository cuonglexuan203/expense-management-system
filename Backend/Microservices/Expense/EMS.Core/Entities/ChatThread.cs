using EMS.Core.Entities.Common;

namespace EMS.Core.Entities
{
    public class ChatThread: BaseEntity<int>
    {
        public Guid UserId { get; set; }
        public string Title { get; set; } = default!;
        public bool IsActive { get; set; } = true;

        // Navigations
        public ICollection<ChatMessage> ChatMessages { get; set; } = [];
    }
}
