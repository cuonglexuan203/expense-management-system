using AutoMapper;
using AutoMapper.QueryableExtensions;
using EMS.Application.Common.Interfaces.DbContext;
using EMS.Application.Common.Interfaces.Services;
using EMS.Application.Features.Categories.Queries.GetCategory;
using MediatR;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Logging;

namespace EMS.Application.Features.Categories.Queries.GetCategories
{
    public record GetCategoriesQuery : IRequest<List<CategoryDto>>;

    public class GetCategoriesQueryHandler : IRequestHandler<GetCategoriesQuery, List<CategoryDto>>
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

        public async Task<List<CategoryDto>> Handle(GetCategoriesQuery request, CancellationToken cancellationToken)
        {
            var userId = _currentUserService.Id;

            var categories = await _context.Categories
                .Include(c => c.Transactions)
                .Include(c => c.Icon)
                .Where(c => c.UserId == userId && !c.IsDeleted)
                .ProjectTo<CategoryDto>(_mapper.ConfigurationProvider)
                .AsNoTracking()
                .ToListAsync(cancellationToken);

            _logger.LogInformation("Successfully retrieved {CategoryCount} categories for user: {UserId}",
                categories.Count,
                userId);

            return categories;
        }
    }
}