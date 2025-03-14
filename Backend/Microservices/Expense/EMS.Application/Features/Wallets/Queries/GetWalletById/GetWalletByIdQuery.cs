using EMS.Application.Common.Exceptions;
using EMS.Application.Common.Interfaces.Services;
using EMS.Application.Features.Wallets.Dtos;
using EMS.Application.Features.Wallets.Services;
using MediatR;
using Microsoft.Extensions.Logging;

namespace EMS.Application.Features.Wallets.Queries.GetWalletById
{
    public record GetWalletByIdQuery(int WalletId) : IRequest<WalletDto>;

    public class GetWalletByIdQueryHandler : IRequestHandler<GetWalletByIdQuery, WalletDto>
    {
        private readonly ILogger<GetWalletByIdQueryHandler> _logger;
        private readonly IWalletService _walletService;
        private readonly ICurrentUserService _currentUserService;

        public GetWalletByIdQueryHandler(
            ILogger<GetWalletByIdQueryHandler> logger, 
            IWalletService walletService,
            ICurrentUserService currentUserService)
        {
            _logger = logger;
            _walletService = walletService;
            _currentUserService = currentUserService;
        }
        public async Task<WalletDto> Handle(GetWalletByIdQuery request, CancellationToken cancellationToken)
        {
            var walletDto = await _walletService.GetWalletByIdAsync(request.WalletId)
                ?? throw new NotFoundException($"Wallet with id {request.WalletId} not found by user {_currentUserService.Id}");

            return walletDto;
        }
    }
}
