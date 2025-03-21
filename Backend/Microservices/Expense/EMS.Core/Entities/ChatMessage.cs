using EMS.Core.Entities.Common;
using EMS.Core.Enums;

namespace EMS.Core.Entities
{
    public class ChatMessage: BaseAuditableEntity<int>
    {
        public int ChatThreadId { get; set; }
        public string? UserId { get; set; }
        public MessageRole Role { get; set; } = MessageRole.User;
        public string? Content { get; set; }

        // Navigations
        public ChatThread ChatThread { get; set; } = default!;
        public ICollection<Media> Medias { get; set; } = [];
        public Transaction? Transaction { get; set; }
        public ChatExtraction? ChatExtraction { get; set; }
        //public ICollection<ExtractedTransaction> ExtractedTransactions { get; set; } = [];

        #region Behaviors
        public static ChatMessage CreateUserMessage(int chatThreadId, string userId, string? content)
        {
            var message = new ChatMessage
            {
                ChatThreadId = chatThreadId,
                UserId = userId,
                Role = MessageRole.User,
                Content = content
            };

            return message;
        }

        public static ChatMessage CreateSystemMessage(int chatThreadId, string? content)
        {
            var message = new ChatMessage
            {
                ChatThreadId = chatThreadId,
                Role = MessageRole.System,
                Content = content
            };

            return message;
        }
        #endregion
    }
}
