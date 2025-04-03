using EMS.Application.Features.Chats.Common.Dtos;

namespace EMS.Application.Common.DTOs
{
    public class MessageExtractionResponse
    {
        public string Introduction { get; set; } = default!;
        public ExtractedTransactionDto[] Transactions { get; set; } = [];
    }
}
