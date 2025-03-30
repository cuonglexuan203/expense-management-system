using AutoMapper;
using EMS.Application.Common.Extensions;
using EMS.Application.Common.Interfaces.DbContext;
using EMS.Application.Common.Interfaces.Services;
using EMS.Application.Common.Models;
using EMS.Application.Features.Categories.Dtos;
using EMS.Core.Enums;
using EMS.Core.Specifications;
using MediatR;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Logging;

namespace EMS.Application.Features.Categories.Queries.GetCategories
{
    public record GetCategoriesQuery(CategorySpecParams SpecParams) : IRequest<PaginatedList<CategoryDto>>;

    public class GetCategoriesQueryHandler : IRequestHandler<GetCategoriesQuery, PaginatedList<CategoryDto>>
    {
        private readonly ILogger<GetCategoriesQueryHandler> _logger;
        private readonly IApplicationDbContext _context;
        private readonly IMapper _mapper;
        private readonly ICurrentUserService _currentUserService;

        public GetCategoriesQueryHandler(
            ILogger<GetCategoriesQueryHandler> logger,
            IApplicationDbContext context,
            IMapper mapper,
            ICurrentUserService currentUserService)
        {
            _logger = logger;
            _context = context;
            _mapper = mapper;
            _currentUserService = currentUserService;
        }

        public async Task<PaginatedList<CategoryDto>> Handle(GetCategoriesQuery request, CancellationToken cancellationToken)
        {
            var userId = _currentUserService.Id;
            var specParams = request.SpecParams;

            var query = _context.Categories
                .Where(e => e.UserId == userId && !e.IsDeleted)
                .AsNoTracking();

            if (!string.IsNullOrEmpty(specParams.Name))
            {
                query = query.Where(e => DatabaseFunctions.Unaccent(e.Name.ToLower())
                .Contains(DatabaseFunctions.Unaccent(specParams.Name.ToLower())));
            }

            if(specParams.Type != null)
            {
                query = query.Where(e => e.Type == specParams.Type);
            }

            if(specParams.FinancialFlowType != null)
            {
                query = query.Where(e => e.FinancialFlowType == specParams.FinancialFlowType);
            }

            if (specParams.Sort == SortDirection.ASC)
            {
                query = query.OrderBy(e => e.CreatedAt);
            }
            else
            {
                query = query.OrderByDescending(e => e.CreatedAt);
            }

            var dtoQuery = _mapper.ProjectTo<CategoryDto>(query);

            var result = await dtoQuery.ToPaginatedList(specParams.PageNumber, specParams.PageSize);

            return result;
        }
    }
}