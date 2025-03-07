using EMS.Application.Common.Exceptions;
using EMS.Application.Common.Interfaces.DbContext;
using EMS.Application.Common.Interfaces.Services;
using MediatR;
using Microsoft.EntityFrameworkCore;

namespace EMS.Application.Features.Category.Commands.UpdateCategory
{
    public record UpdateCategoryCommand : IRequest<int>
    {
        public int Id { get; init; }
        public string Name { get; init; } = default!;
        public int? IconId { get; init; }
    }

    public class UpdateCategoryCommandHandler : IRequestHandler<UpdateCategoryCommand, int>
    {
        private readonly IApplicationDbContext _context;
        private readonly ICurrentUserService _currentUserService;

        public UpdateCategoryCommandHandler(IApplicationDbContext context, ICurrentUserService currentUserService)
        {
            _context = context;
            _currentUserService = currentUserService;
        }

        public async Task<int> Handle(UpdateCategoryCommand request, CancellationToken cancellationToken)
        {
            var userId = _currentUserService.Id;

            var category = await _context.Categories
                .FirstOrDefaultAsync(c => c.Id == request.Id && c.UserId == userId && !c.IsDeleted, cancellationToken);

            if (category == null)
            {
                throw new NotFoundException($"{nameof(Core.Entities.Category)} with ID {request.Id} not found");
            }

            category.Name = request.Name;
            // Update IconId property when implemented

            await _context.SaveChangesAsync(cancellationToken);

            return category.Id;
        }
    }
}