using EMS.Application.Common.Mappings;
using EMS.Core.Entities;
using EMS.Core.Enums;

namespace EMS.Application.Features.Chats.Common.Dtos
{
    public class ChatThreadDto : IMapFrom<ChatThread>
    {
        public string UserId { get; set; } = default!;
        public string Title { get; set; } = default!;
        public bool IsActive { get; set; }
        public ChatThreadType Type { get; set; }
    }
}
