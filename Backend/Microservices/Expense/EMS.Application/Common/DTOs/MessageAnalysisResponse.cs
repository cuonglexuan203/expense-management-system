using EMS.Application.Features.Chats.Dtos;

namespace EMS.Application.Common.DTOs
{
    public class MessageAnalysisResponse
    {
        public string Introduction { get; set; } = default!;
        public ExtractedTransactionDto[] Transactions { get; set; } = [];
        public Notification? Notification { get; set; }
    }
    public class Notification
    {
        public string Title { get; set; } = default!;
        public string Body { get; set; } = default!;
    }
}
