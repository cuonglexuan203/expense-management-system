using EMS.Application.Features.Wallets.Dtos;
using EMS.Application.Features.Wallets.Queries.GetWalletSummary;
using EMS.Core.Enums;

namespace EMS.Application.Features.Wallets.Services
{
    public interface IWalletService
    {
        Task<WalletDto?> GetWalletByIdAsync(int id, CancellationToken cancellationToken = default);
        Task<WalletBalanceSummary> GetWalletBalanceSummaryAsync(
            int walletId,
            TimePeriod period,
            CancellationToken cancellationToken = default);
        Task<WalletBalanceSummary> GetWalletBalanceSummaryAsync(
            string userId,
            int walletId,
            TimePeriod period,
            CancellationToken cancellationToken = default);
        Task CacheWalletBalanceSummariesAsync(int walletId);
        Task CacheWalletBalanceSummariesAsync(string userId, int walletId);
    }
}
