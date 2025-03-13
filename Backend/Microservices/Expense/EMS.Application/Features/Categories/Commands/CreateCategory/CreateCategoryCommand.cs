using AutoMapper;
using EMS.Application.Common.Interfaces.DbContext;
using EMS.Application.Common.Interfaces.Services;
using EMS.Application.Features.Categories.Queries.GetCategory;
using EMS.Core.Enums;
using MediatR;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Logging;

namespace EMS.Application.Features.Categories.Commands.CreateCategory
{
    public record CreateCategoryCommand : IRequest<CategoryDto>
    {
        public string Name { get; init; } = default!;
        public bool IsDefault { get; init; }
        public TransactionType TransactionType { get; init; }
        public Guid? IconId { get; init; }
    }

    public class CreateCategoryCommandHandler : IRequestHandler<CreateCategoryCommand, CategoryDto>
    {
        private readonly ILogger<CreateCategoryCommandHandler> _logger;
        private readonly IApplicationDbContext _context;
        private readonly ICurrentUserService _currentUserService;
        private readonly IMapper _mapper;

        public CreateCategoryCommandHandler(ILogger<CreateCategoryCommandHandler> logger, IApplicationDbContext context, ICurrentUserService currentUserService, IMapper mapper)
        {
            _logger = logger;
            _context = context;
            _currentUserService = currentUserService;
            _mapper = mapper;
        }

        public async Task<CategoryDto> Handle(CreateCategoryCommand request, CancellationToken cancellationToken)
        {
            var userId = _currentUserService.Id;

            var category = new Core.Entities.Category
            {
                Name = request.Name,
                Type = request.IsDefault ? CategoryType.Default : CategoryType.Custom,
                UserId = userId!,
                IconId = request.IconId
            };

            try
            {
                _context.Categories.Add(category);
                await _context.SaveChangesAsync(cancellationToken);

                var createdCategory = await _context.Categories
                    .Include(c => c.Transactions)
                    .Include(c => c.Icon)
                    .AsNoTracking()
                    .FirstAsync(c => c.Id == category.Id, cancellationToken);

                _logger.LogInformation("Category created successfully. ID: {CategoryId}, Name: {CategoryName}, Type: {CategoryType}, UserId: {UserId}, IconId: {IconId}, HasIcon: {HasIcon}",
                    createdCategory.Id,
                    createdCategory.Name,
                    createdCategory.Type,
                    createdCategory.UserId,
                    createdCategory.IconId,
                    createdCategory.Icon != null);

                return _mapper.Map<CategoryDto>(createdCategory);
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error occurred while creating category. Name: {CategoryName}, UserId: {UserId}", request.Name, userId);
                throw;
            }
        }
    }
}