using AutoMapper;
using AutoMapper.QueryableExtensions;
using EMS.Application.Common.Interfaces.DbContext;
using EMS.Application.Common.Interfaces.Services;
using EMS.Application.Features.Category.Queries.GetCategory;
using MediatR;
using Microsoft.EntityFrameworkCore;

namespace EMS.Application.Features.Category.Queries.GetCategories
{
    public record GetCategoriesQuery : IRequest<List<CategoryDto>>;

    public class GetCategoriesQueryHandler : IRequestHandler<GetCategoriesQuery, List<CategoryDto>>
    {
        private readonly IApplicationDbContext _context;
        private readonly IMapper _mapper;
        private readonly ICurrentUserService _currentUserService;

        public GetCategoriesQueryHandler(IApplicationDbContext context, IMapper mapper, ICurrentUserService currentUserService)
        {
            _context = context;
            _mapper = mapper;
            _currentUserService = currentUserService;
        }

        public async Task<List<CategoryDto>> Handle(GetCategoriesQuery request, CancellationToken cancellationToken)
        {
            var userId = _currentUserService.Id;

            return await _context.Categories
                .Include(c => c.Transactions)
                .Where(c => c.UserId == userId && !c.IsDeleted)
                .ProjectTo<CategoryDto>(_mapper.ConfigurationProvider)
                .ToListAsync(cancellationToken);
        }
    }
}