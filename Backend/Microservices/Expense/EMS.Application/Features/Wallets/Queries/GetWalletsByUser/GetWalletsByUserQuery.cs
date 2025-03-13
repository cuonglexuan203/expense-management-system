using AutoMapper;
using AutoMapper.QueryableExtensions;
using EMS.Application.Common.Interfaces.DbContext;
using EMS.Application.Common.Interfaces.Services;
using EMS.Application.Features.Wallets.Dtos;
using MediatR;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Logging;

namespace EMS.Application.Features.Wallets.Queries.GetWalletsByUser
{
    public record GetWalletsByUserQuery : IRequest<List<WalletDto>>;

    public class GetWalletsByUserQueryHandler : IRequestHandler<GetWalletsByUserQuery, List<WalletDto>>
    {
        private readonly ILogger<GetWalletsByUserQueryHandler> _logger;
        private readonly IApplicationDbContext _context;
        private readonly IMapper _mapper;
        private readonly ICurrentUserService _user;

        public GetWalletsByUserQueryHandler(ILogger<GetWalletsByUserQueryHandler> logger, IApplicationDbContext context,
            IMapper mapper, ICurrentUserService user)
        {
            _logger = logger;
            _context = context;
            _mapper = mapper;
            _user = user;
        }
        public async Task<List<WalletDto>> Handle(GetWalletsByUserQuery request, CancellationToken cancellationToken)
        {
            var userId = _user.Id;

            var wallets = await _context.Wallets
                .Where(e => e.UserId == userId && !e.IsDeleted)
                .OrderBy(e => e.CreatedAt)
                //.Select(e => new
                //{
                //    Id = e.Id,
                //    Name = e.Name,
                //    Balance = e.Balance,
                //    Description = e.Description,
                //    CreatedAt = e.CreatedAt,
                //})
                .ProjectTo<WalletDto>(_mapper.ConfigurationProvider)
                .ToListAsync();

            return wallets;
        }
    }
}
