using EMS.Application.Common.Attributes;
using EMS.Application.Common.Utils;
using EMS.Application.Features.Wallets.Services;
using EMS.Core.Enums;
using MediatR;
using Microsoft.Extensions.Logging;

namespace EMS.Application.Features.Wallets.Queries.GetWalletSummary
{
    [UserCacheableQuery(CacheKeyGenerator.QueryKeys.WalletByUser)]
    public record GetWalletSummaryQuery(int WalletId, WalletSummaryPeriod period = WalletSummaryPeriod.AllTime) : IRequest<WalletBalanceSummary>;

    public class GetWalletSummaryQueryHandler : IRequestHandler<GetWalletSummaryQuery, WalletBalanceSummary>
    {
        private readonly ILogger<GetWalletSummaryQuery> _logger;
        private readonly IWalletService _walletService;

        public GetWalletSummaryQueryHandler(ILogger<GetWalletSummaryQuery> logger, IWalletService walletService)
        {
            _logger = logger;
            _walletService = walletService;
        }

        public async Task<WalletBalanceSummary> Handle(GetWalletSummaryQuery request, CancellationToken cancellationToken)
        {
            var result = await _walletService.GetWalletBalanceSummaryAsync(request.WalletId, request.period, cancellationToken);

            return result;
        }
    }
}
