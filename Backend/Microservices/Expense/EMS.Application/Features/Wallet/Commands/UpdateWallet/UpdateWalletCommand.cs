using AutoMapper;
using EMS.Application.Common.Exceptions;
using EMS.Application.Common.Interfaces.DbContext;
using EMS.Application.Common.Interfaces.Services;
using EMS.Application.Features.Wallet.Dtos;
using MediatR;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Logging;

namespace EMS.Application.Features.Wallet.Commands.UpdateWallet
{
    public record UpdateWalletCommand : IRequest<WalletDto>
    {
        public int Id { get; init; }
        public string Name { get; init; } = default!;
        public float Balance { get; init; }
        public string? Description { get; init; }
    }

    public class UpdateWalletCommandHandler : IRequestHandler<UpdateWalletCommand, WalletDto>
    {
        private readonly ILogger<UpdateWalletCommandHandler> _logger;
        private readonly IApplicationDbContext _context;
        private readonly ICurrentUserService _currentUserService;
        private readonly IMapper _mapper;

        public UpdateWalletCommandHandler(
            ILogger<UpdateWalletCommandHandler> logger,
            IApplicationDbContext context,
            ICurrentUserService currentUserService,
            IMapper mapper)
        {
            _logger = logger;
            _context = context;
            _currentUserService = currentUserService;
            _mapper = mapper;
        }

        public async Task<WalletDto> Handle(UpdateWalletCommand request, CancellationToken cancellationToken)
        {
            var userId = _currentUserService.Id;

            var wallet = await _context.Wallets
                //.Include(w => w.Transactions)
                .FirstOrDefaultAsync(w => w.Id == request.Id && w.UserId == userId && !w.IsDeleted, cancellationToken);

            if (wallet == null)
            {
                throw new NotFoundException($"{nameof(Core.Entities.Wallet)} with ID {request.Id} not found");
            }

            try
            {
                wallet.Name = request.Name;
                wallet.Balance = request.Balance;
                wallet.Description = request.Description;

                await _context.SaveChangesAsync(cancellationToken);

                _logger.LogInformation("Wallet updated successfully - ID: {WalletId}, Name: {NewName}, Balance: {NewBalance}, Description: {NewDescription}",
                    wallet.Id, wallet.Name, wallet.Balance, wallet.Description);

                return _mapper.Map<WalletDto>(wallet);
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error occurred while updating wallet. ID: {WalletId}, UserId: {UserId}", request.Id, userId);
                throw;
            }
        }
    }
}