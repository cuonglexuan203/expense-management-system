using EMS.Application.Features.Chats.Dtos;

namespace EMS.Application.Common.DTOs
{
    // NOTE: Financial agent response
    public record FinancialResponse(
        ExtractedTransactionDto[] TextExtractions,
        ExtractedTransactionDto[] ImageExtractions,
        ExtractedTransactionDto[] AudioExtractions);
}
