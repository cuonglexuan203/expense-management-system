using EMS.Application.Features.Wallets.Queries.GetWalletSummary;
using EMS.Core.Enums;

namespace EMS.Application.Features.Wallets.Services
{
    public interface IWalletService
    {
        Task<WalletBalanceSummary> GetWalletBalanceSummaryAsync(int walletId, WalletSummaryPeriod period, CancellationToken cancellationToken = default);
    }
}
