using EMS.Application.Common.Exceptions;
using EMS.Application.Common.Interfaces.DbContext;
using EMS.Application.Common.Interfaces.Services;
using MediatR;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Logging;

namespace EMS.Application.Features.Category.Commands.UpdateCategory
{
    public record UpdateCategoryCommand : IRequest<int>
    {
        public int Id { get; init; }
        public string Name { get; init; } = default!;
        public Guid? IconId { get; init; }
    }

    public class UpdateCategoryCommandHandler : IRequestHandler<UpdateCategoryCommand, int>
    {
        private readonly ILogger<UpdateCategoryCommandHandler> _logger;
        private readonly IApplicationDbContext _context;
        private readonly ICurrentUserService _currentUserService;

        public UpdateCategoryCommandHandler(
            ILogger<UpdateCategoryCommandHandler> logger,
            IApplicationDbContext context,
            ICurrentUserService currentUserService)
        {
            _logger = logger;
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
                _logger.LogWarning("Category with ID: {CategoryId} not found for user: {UserId}",
                    request.Id, userId);
                throw new NotFoundException($"{nameof(Core.Entities.Category)} with ID {request.Id} not found");
            }

            category.Name = request.Name;
            category.IconId = request.IconId;

            await _context.SaveChangesAsync(cancellationToken);

            _logger.LogInformation("Category updated successfully - ID: {CategoryId}, Name: {NewName}, IconId: {NewIconId}",
                category.Id, category.Name, category.IconId);

            return category.Id;
        }
    }
}