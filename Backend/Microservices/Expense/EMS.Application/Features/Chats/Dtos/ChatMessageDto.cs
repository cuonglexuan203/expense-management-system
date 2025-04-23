using EMS.Application.Common.DTOs;
using EMS.Application.Common.Mappings;
using EMS.Core.Entities;
using EMS.Core.Enums;

namespace EMS.Application.Features.Chats.Dtos
{
    public class ChatMessageDto : IMapFrom<ChatMessage>
    {
        public int Id { get; set; }
        public int ChatThreadId { get; set; }
        public string? UserId { get; set; }
        public MessageRole Role { get; set; }
        public string? Content { get; set; }
        public DateTimeOffset CreatedAt { get; set; }
        public ICollection<MediaDto> Medias { get; set; } = [];
        public ICollection<ExtractedTransactionDto> ExtractedTransactions { get; set; } = [];
    }
}
