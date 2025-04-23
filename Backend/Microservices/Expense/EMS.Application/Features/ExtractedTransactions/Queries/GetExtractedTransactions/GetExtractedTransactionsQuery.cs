using AutoMapper;
using EMS.Application.Common.Extensions;
using EMS.Application.Common.Interfaces.DbContext;
using EMS.Application.Common.Interfaces.Services;
using EMS.Application.Common.Models;
using EMS.Application.Features.ExtractedTransactions.Dtos;
using EMS.Core.Enums;
using EMS.Core.Specifications;
using MediatR;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Logging;

namespace EMS.Application.Features.ExtractedTransactions.Queries.GetExtractedTransactions
{
    public record GetExtractedTransactionsQuery(ExtractedTransactionSpecParams SpecParams) : IRequest<PaginatedList<ExtractedTransactionDto>>;

    public class GetExtractedTransactionsQueryHandler : IRequestHandler<GetExtractedTransactionsQuery, PaginatedList<ExtractedTransactionDto>>
    {
        private readonly ILogger<GetExtractedTransactionsQueryHandler> _logger;
        private readonly IApplicationDbContext _context;
        private readonly IMapper _mapper;
        private readonly ICurrentUserService _currentUserService;

        public GetExtractedTransactionsQueryHandler(
            ILogger<GetExtractedTransactionsQueryHandler> logger,
            IApplicationDbContext context,
            IMapper mapper,
            ICurrentUserService currentUserService)
        {
            _logger = logger;
            _context = context;
            _mapper = mapper;
            _currentUserService = currentUserService;
        }

        public async Task<PaginatedList<ExtractedTransactionDto>> Handle(GetExtractedTransactionsQuery request, CancellationToken cancellationToken)
        {
            var specParams = request.SpecParams;
            var userId = _currentUserService.Id;

            var query = _context.ExtractedTransactions
                .Where(e => !e.IsDeleted
                    && e.UserId == userId)
                .AsNoTracking();

            if (!string.IsNullOrEmpty(specParams.Name))
            {
                query = query.Where(e => DatabaseFunctions.Unaccent(e.Name.ToLower())
                .Contains(DatabaseFunctions.Unaccent(specParams.Name.ToLower())));
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

            var dtoQuery = _mapper.ProjectTo<ExtractedTransactionDto>(query);

            var result = await dtoQuery.ToPaginatedList(specParams.PageNumber, specParams.PageSize);

            return result;
        }
    }
}
