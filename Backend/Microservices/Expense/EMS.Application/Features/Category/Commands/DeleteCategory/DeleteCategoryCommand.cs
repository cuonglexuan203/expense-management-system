using EMS.Application.Common.Exceptions;
using EMS.Application.Common.Interfaces.DbContext;
using EMS.Application.Common.Interfaces.Services;
using MediatR;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Logging;

namespace EMS.Application.Features.Category.Commands.DeleteCategory
{
    public record DeleteCategoryCommand(int Id) : IRequest<Unit>;

    public class DeleteCategoryCommandHandler : IRequestHandler<DeleteCategoryCommand, Unit>
    {
        private readonly ILogger<DeleteCategoryCommandHandler> _logger;
        private readonly IApplicationDbContext _context;
        private readonly ICurrentUserService _currentUserService;

        public DeleteCategoryCommandHandler(
            ILogger<DeleteCategoryCommandHandler> logger,
            IApplicationDbContext context,
            ICurrentUserService currentUserService)
        {
            _logger = logger;
            _context = context;
            _currentUserService = currentUserService;
        }

        public async Task<Unit> Handle(DeleteCategoryCommand request, CancellationToken cancellationToken)
        {
            var userId = _currentUserService.Id;

            var category = await _context.Categories
                .Include(c => c.Transactions)
                .FirstOrDefaultAsync(c => c.Id == request.Id && c.UserId == userId && !c.IsDeleted, cancellationToken);

            if (category == null)
            {
                _logger.LogError("Attempted to delete non-existent category. ID: {CategoryId}, UserId: {UserId}",
                    request.Id, userId);
                throw new NotFoundException($"{nameof(Core.Entities.Category)} with ID {request.Id} not found");
            }

            if (category.Transactions.Any())
            {
                _logger.LogError("Attempted to delete category with transactions. ID: {CategoryId}, Name: {CategoryName}, TransactionCount: {TransactionCount}",
                    category.Id, category.Name, category.Transactions.Count);
                throw new InvalidOperationException("Cannot delete a category that has transactions. Please remove or reassign the transactions first.");
            }

            // Soft delete
            category.IsDeleted = true;
            category.DeletedAt = DateTimeOffset.UtcNow;
            category.DeletedBy = userId;

            await _context.SaveChangesAsync(cancellationToken);

            _logger.LogInformation("Category deleted successfully. ID: {CategoryId}, Name: {CategoryName}, UserId: {UserId}",
                category.Id, category.Name, category.UserId);

            return Unit.Value;
        }
    }
}