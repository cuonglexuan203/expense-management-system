using EMS.Application.Features.ExtractedTransactions.Dtos;

namespace EMS.Application.Common.DTOs
{
    // NOTE: Financial agent response
    public record FinancialResponse(
        ExtractedTransactionDto[] TextExtractions,
        ExtractedTransactionDto[] ImageExtractions,
        ExtractedTransactionDto[] AudioExtractions);
}
