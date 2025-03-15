using AutoMapper;
using EMS.Application.Common.Exceptions;
using EMS.Application.Common.Interfaces.DbContext;
using EMS.Application.Common.Interfaces.Services;
using EMS.Application.Features.Categories.Dtos;
using MediatR;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Logging;

namespace EMS.Application.Features.Categories.Queries.GetCategoryById
{
    public record GetCategoryByIdQuery(int CategoryId) : IRequest<CategoryDto>;

    public class GetCategoryByIdQueryHandler : IRequestHandler<GetCategoryByIdQuery, CategoryDto>
    {
        private readonly ILogger<GetCategoryByIdQueryHandler> _logger;
        private readonly IApplicationDbContext _context;
        private readonly IMapper _mapper;
        private readonly ICurrentUserService _currentUserService;

        public GetCategoryByIdQueryHandler(
            ILogger<GetCategoryByIdQueryHandler> logger,
            IApplicationDbContext context,
            IMapper mapper,
            ICurrentUserService currentUserService)
        {
            _logger = logger;
            _context = context;
            _mapper = mapper;
            _currentUserService = currentUserService;
        }

        public async Task<CategoryDto> Handle(GetCategoryByIdQuery request, CancellationToken cancellationToken)
        {
            var userId = _currentUserService.Id;

            var category = await _context.Categories
                //.Include(c => c.Transactions)
                .AsNoTracking()
                .Include(c => c.Icon)
                .FirstOrDefaultAsync(c => c.Id == request.CategoryId &&
                (c.UserId == userId || c.UserId == null) && // allow default and custom categories
                !c.IsDeleted, cancellationToken)
                ?? throw new NotFoundException($"{nameof(Core.Entities.Category)} with ID {request.CategoryId} not found");

            //_logger.LogInformation("Successfully retrieved category. ID: {CategoryId}, Name: {CategoryName}, TransactionCount: {TransactionCount}, HasIcon: {HasIcon}",
            //    category.Id,
            //    category.Name,
            //    category.Transactions.Count,
            //    category.Icon != null);

            return _mapper.Map<CategoryDto>(category);
        }
    }
}