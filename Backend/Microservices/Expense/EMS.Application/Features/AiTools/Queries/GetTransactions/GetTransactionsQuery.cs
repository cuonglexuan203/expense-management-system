using AutoMapper;
using EMS.Application.Common.Extensions;
using EMS.Application.Common.Interfaces.DbContext;
using EMS.Application.Features.Transactions.Dtos;
using EMS.Core.Enums;
using EMS.Core.Specifications;
using MediatR;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Logging;

namespace EMS.Application.Features.AiTools.Queries.GetTransactions
{
    public record GetTransactionsQuery(string UserId, TransactionSpecParams SpecParams) : IRequest<List<TransactionDto>>;

    public class GetTransactionsQueryHandler : IRequestHandler<GetTransactionsQuery, List<TransactionDto>>
    {
        private readonly ILogger<GetTransactionsQueryHandler> _logger;
        private readonly IApplicationDbContext _context;
        private readonly IMapper _mapper;

        public GetTransactionsQueryHandler(
            ILogger<GetTransactionsQueryHandler> logger,
            IApplicationDbContext context,
            IMapper mapper)
        {
            _logger = logger;
            _context = context;
            _mapper = mapper;
        }

        public async Task<List<TransactionDto>> Handle(GetTransactionsQuery request, CancellationToken cancellationToken)
        {
            var specParams = request.SpecParams;
            var userId = request.UserId;

            var query = _context.Transactions
                .Where(e => !e.IsDeleted
                    && !e.Wallet.IsDeleted
                    && e.UserId == userId)
                .AsNoTracking();

            if (specParams.Period != null)
            {
                query = query.FilterTransactionsByPeriod((TimePeriod)specParams.Period);
            }

            if (!string.IsNullOrEmpty(specParams.Name))
            {
                query = query.Where(e => DatabaseFunctions.Unaccent(e.Name.ToLower())
                .Contains(DatabaseFunctions.Unaccent(specParams.Name.ToLower())));
            }

            if (specParams.WalletId != null)
            {
                query = query.Where(e => e.Wallet.Id == specParams.WalletId);
            }

            if (specParams.CategoryId != null)
            {
                query = query.Where(e => e.Category != null && !e.Category.IsDeleted && e.Category.Id == specParams.CategoryId);
            }

            if (specParams.Type != null)
            {
                query = query.Where(e => e.Type == specParams.Type);
            }

            // TODO: Sort by CreatedAt/OccurredAt or both
            if (specParams.Sort == SortDirection.ASC)
            {
                query = query.OrderBy(e => e.OccurredAt);
            }
            else
            {
                query = query.OrderByDescending(e => e.OccurredAt);
            }

            var result = await query.ProjectToListAsync<TransactionDto>(_mapper.ConfigurationProvider);

            return result;
        }
    }
}
