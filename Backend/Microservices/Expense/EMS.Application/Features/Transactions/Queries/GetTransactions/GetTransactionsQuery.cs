using AutoMapper;
using EMS.Application.Common.Extensions;
using EMS.Application.Common.Interfaces.DbContext;
using EMS.Application.Common.Models;
using EMS.Application.Features.Transactions.Dtos;
using EMS.Core.Enums;
using EMS.Core.Specifications;
using MediatR;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Logging;

namespace EMS.Application.Features.Transactions.Queries.GetTransactions
{
    public record GetTransactionsQuery(TransactionSpecParams SpecParams) : IRequest<PaginatedList<TransactionDto>>;

    public class GetTransactionsQueryHandler : IRequestHandler<GetTransactionsQuery, PaginatedList<TransactionDto>>
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

        public async Task<PaginatedList<TransactionDto>> Handle(GetTransactionsQuery request, CancellationToken cancellationToken)
        {
            var specParams = request.SpecParams;

            var query = _context.Transactions
                .Where(e => !e.IsDeleted && !e.Wallet.IsDeleted)
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

            if(specParams.Type != null)
            {
                query = query.Where(e => e.Type == specParams.Type);
            }

            // TODO: Sort by CreatedAt/OccurredAt or both
            if(specParams.Sort == SortDirection.ASC)
            {
                query = query.OrderBy(e => e.OccurredAt);
            }
            else
            {
                query = query.OrderByDescending(e => e.OccurredAt);
            }

            var dtoQuery = _mapper.ProjectTo<TransactionDto>(query);

            var result = await dtoQuery.ToPaginatedList(specParams.PageNumber, specParams.PageSize);

            return result;
        }
    }
}
