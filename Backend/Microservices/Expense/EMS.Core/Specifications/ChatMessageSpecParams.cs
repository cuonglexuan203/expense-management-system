using EMS.Core.Enums;
using EMS.Core.Specifications.Common;

namespace EMS.Core.Specifications
{
    public class ChatMessageSpecParams : PaginationSpecParams
    {
        public MessageRole? Role { get; set; }
        public string? Content { get; set; }
    }
}
