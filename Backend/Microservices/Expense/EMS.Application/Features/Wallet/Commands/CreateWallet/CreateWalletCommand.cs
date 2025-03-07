using AutoMapper;
using EMS.Application.Common.Interfaces.DbContext;
using EMS.Application.Common.Interfaces.Services;
using EMS.Application.Features.Wallet.Common;
using MediatR;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Logging;
using System;

namespace EMS.Application.Features.Wallet.Commands.CreateWallet
{
    public record CreateWalletCommand : IRequest<WalletDto>
    {
        public string Name { get; init; } = default!;
        public float Balance { get; init; }
        public string? Description { get; init; }
    }

    public class CreateWalletCommandHandler : IRequestHandler<CreateWalletCommand, WalletDto>
    {
        private readonly ILogger<CreateWalletCommandHandler> _logger;
        private readonly IApplicationDbContext _context;
        private readonly ICurrentUserService _currentUserService;
        private readonly IMapper _mapper;

        public CreateWalletCommandHandler(
            ILogger<CreateWalletCommandHandler> logger,
            IApplicationDbContext context,
            ICurrentUserService currentUserService,
            IMapper mapper)
        {
            _logger = logger;
            _context = context;
            _currentUserService = currentUserService;
            _mapper = mapper;
        }

        public async Task<WalletDto> Handle(CreateWalletCommand request, CancellationToken cancellationToken)
        {
            _logger.LogInformation("Creating new wallet. Name: {WalletName}, Balance: {Balance}, UserId: {UserId}",
                request.Name,
                request.Balance,
                _currentUserService.Id);

            var userId = _currentUserService.Id;

            var wallet = new Core.Entities.Wallet
            {
                Name = request.Name,
                Balance = request.Balance,
                Description = request.Description,
                UserId = userId!
            };

            try
            {
                _context.Wallets.Add(wallet);
                await _context.SaveChangesAsync(cancellationToken);

                _logger.LogDebug("Wallet saved to database with ID: {WalletId}", wallet.Id);

                var createdWallet = await _context.Wallets
                    .Include(w => w.Transactions)
                    .FirstAsync(w => w.Id == wallet.Id, cancellationToken);

                _logger.LogInformation("Wallet created successfully. ID: {WalletId}, Name: {WalletName}, Balance: {Balance}, UserId: {UserId}",
                    createdWallet.Id,
                    createdWallet.Name,
                    createdWallet.Balance,
                    createdWallet.UserId);

                return _mapper.Map<WalletDto>(createdWallet);
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error occurred while creating wallet. Name: {WalletName}, UserId: {UserId}", request.Name, userId);
                throw;
            }
        }
    }
}