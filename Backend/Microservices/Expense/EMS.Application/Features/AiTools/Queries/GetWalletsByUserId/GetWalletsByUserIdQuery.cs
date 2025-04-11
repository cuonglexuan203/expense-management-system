using AutoMapper;
using AutoMapper.QueryableExtensions;
using EMS.Application.Common.Interfaces.DbContext;
using EMS.Application.Features.Wallets.Dtos;
using MediatR;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Logging;

namespace EMS.Application.Features.AiTools.Queries.GetWalletsByUserId
{
    public record GetWalletsByUserIdQuery(string UserId) : IRequest<List<WalletDto>>;

    public class GetWalletsByUserQueryHandler : IRequestHandler<GetWalletsByUserIdQuery, List<WalletDto>>
    {
        private readonly ILogger<GetWalletsByUserQueryHandler> _logger;
        private readonly IApplicationDbContext _context;
        private readonly IMapper _mapper;

        public GetWalletsByUserQueryHandler(ILogger<GetWalletsByUserQueryHandler> logger, IApplicationDbContext context,
            IMapper mapper)
        {
            _logger = logger;
            _context = context;
            _mapper = mapper;
        }
        public async Task<List<WalletDto>> Handle(GetWalletsByUserIdQuery request, CancellationToken cancellationToken)
        {
            var userId = request.UserId;

            var wallets = await _context.Wallets
                .AsNoTracking()
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
