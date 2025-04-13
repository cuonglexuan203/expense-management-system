using EMS.Core.Enums;

namespace EMS.API.Common.Models.AiToolController
{
    public record UpdateExtractedTransactionsStatusRequest(int WalletId, int MessageId, ConfirmationStatus ConfirmationStatus);
}
