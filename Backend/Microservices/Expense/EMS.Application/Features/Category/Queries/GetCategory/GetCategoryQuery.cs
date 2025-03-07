using AutoMapper;
using EMS.Application.Common.Exceptions;
using EMS.Application.Common.Interfaces.DbContext;
using EMS.Application.Common.Interfaces.Services;
using MediatR;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Logging;

namespace EMS.Application.Features.Category.Queries.GetCategory
{
    public record GetCategoryQuery(int Id) : IRequest<CategoryDto>;

    public class GetCategoryQueryHandler : IRequestHandler<GetCategoryQuery, CategoryDto>
    {
        private readonly ILogger<GetCategoryQueryHandler> _logger;
        private readonly IApplicationDbContext _context;
        private readonly IMapper _mapper;
        private readonly ICurrentUserService _currentUserService;

        public GetCategoryQueryHandler(
            ILogger<GetCategoryQueryHandler> logger,
            IApplicationDbContext context,
            IMapper mapper,
            ICurrentUserService currentUserService)
        {
            _logger = logger;
            _context = context;
            _mapper = mapper;
            _currentUserService = currentUserService;
        }

        public async Task<CategoryDto> Handle(GetCategoryQuery request, CancellationToken cancellationToken)
        {
            var userId = _currentUserService.Id;

            var category = await _context.Categories
                .Include(c => c.Transactions)
                .Include(c => c.Icon)
                .FirstOrDefaultAsync(c => c.Id == request.Id && c.UserId == userId && !c.IsDeleted, cancellationToken);

            if (category == null)
            {
                _logger.LogWarning("Category with ID: {CategoryId} not found for user: {UserId}", request.Id, userId);
                throw new NotFoundException($"{nameof(Core.Entities.Category)} with ID {request.Id} not found");
            }

            _logger.LogInformation("Successfully retrieved category. ID: {CategoryId}, Name: {CategoryName}, TransactionCount: {TransactionCount}, HasIcon: {HasIcon}",
                category.Id,
                category.Name,
                category.Transactions.Count,
                category.Icon != null);

            return _mapper.Map<CategoryDto>(category);
        }
    }
}