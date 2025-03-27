using EMS.Core.Enums;

namespace EMS.API.Common.Models.ExtractedTransactionController
{
    public record struct UpdateExtractedTransactionStatusRequest(int WalletId, ConfirmationStatus ConfirmationStatus);
}
