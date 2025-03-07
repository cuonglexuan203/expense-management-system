using EMS.Application.Common.Interfaces.DbContext;
using EMS.Application.Common.Interfaces.Services;
using EMS.Core.Enums;
using MediatR;

namespace EMS.Application.Features.Category.Commands.CreateCategory
{
    public record CreateCategoryCommand : IRequest<int>
    {
        public string Name { get; init; } = default!;
        public bool IsDefault { get; init; }
        public TransactionType TransactionType { get; init; }
        public int? IconId { get; init; }
    }

    public class CreateCategoryCommandHandler : IRequestHandler<CreateCategoryCommand, int>
    {
        private readonly IApplicationDbContext _context;
        private readonly ICurrentUserService _currentUserService;

        public CreateCategoryCommandHandler(IApplicationDbContext context, ICurrentUserService currentUserService)
        {
            _context = context;
            _currentUserService = currentUserService;
        }

        public async Task<int> Handle(CreateCategoryCommand request, CancellationToken cancellationToken)
        {
            var userId = _currentUserService.Id;

            var category = new Core.Entities.Category
            {
                Name = request.Name,
                Type = request.IsDefault ? CategoryType.Default : CategoryType.Custom,
                UserId = userId!,
                // Add IconId property to Category entity if needed
            };

            _context.Categories.Add(category);
            await _context.SaveChangesAsync(cancellationToken);

            return category.Id;
        }
    }
}