using EMS.Application.Common.Attributes;
using EMS.Application.Common.Utils;
using EMS.Application.Features.Wallets.Services;
using EMS.Core.Enums;
using MediatR;
using Microsoft.Extensions.Logging;
using System;

namespace EMS.Application.Features.Wallets.Queries.GetWalletSummary
{
    [UserCacheableQuery(CacheKeyGenerator.QueryKeys.WalletByUser)]
    public record GetWalletSummaryQuery(
        int WalletId,
        TimePeriod period = TimePeriod.AllTime,
        DateTime? FromDate = null,
        DateTime? ToDate = null) : IRequest<WalletBalanceSummary>;

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
            var result = await _walletService.GetWalletBalanceSummaryAsync(
                request.WalletId,
                request.period,
                request.FromDate,
                request.ToDate,
                cancellationToken);

            return result;
        }
    }
}