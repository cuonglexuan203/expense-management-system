using EMS.Core.Entities.Common;
using EMS.Core.Enums;

namespace EMS.Core.Entities
{
    public class ChatMessage : BaseAuditableEntity<int>
    {
        public int ChatThreadId { get; set; }
        public string? UserId { get; set; }
        public MessageRole Role { get; set; } = MessageRole.Human;
        public string? Content { get; set; }
        public MessageTypes MessageTypes { get; set; }

        // Navigations
        public ChatThread ChatThread { get; set; } = default!;
        public ICollection<Media> Medias { get; set; } = [];
        public ICollection<Transaction> Transaction { get; set; } = [];
        public ChatExtraction? ChatExtraction { get; set; }
        //public ICollection<ExtractedTransaction> ExtractedTransactions { get; set; } = [];

        #region Behaviors
        public static ChatMessage CreateHumanMessage(string userId, int chatThreadId, string? content, MessageTypes messageTypes = MessageTypes.Text)
        {
            var message = new ChatMessage
            {
                UserId = userId,
                ChatThreadId = chatThreadId,
                Role = MessageRole.Human,
                Content = content,
                MessageTypes = messageTypes
            };

            return message;
        }

        public static ChatMessage CreateSystemMessage(int chatThreadId, string? content, MessageTypes messageTypes = MessageTypes.Text)
        {
            var message = new ChatMessage
            {
                ChatThreadId = chatThreadId,
                Role = MessageRole.System,
                Content = content,
                MessageTypes = messageTypes
            };

            return message;
        }
        #endregion
    }
}
