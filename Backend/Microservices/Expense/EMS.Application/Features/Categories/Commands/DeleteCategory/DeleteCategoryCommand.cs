using EMS.Application.Common.Exceptions;
using EMS.Application.Common.Interfaces.DbContext;
using EMS.Application.Common.Interfaces.Services;
using MediatR;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Logging;

namespace EMS.Application.Features.Categories.Commands.DeleteCategory
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
                throw new NotFoundException($"{nameof(Core.Entities.Category)} with ID {request.Id} not found");
            }

            if (category.Transactions.Any())
            {
                throw new InvalidOperationException("Cannot delete a category that has transactions. Please remove or reassign the transactions first.");
            }

            _context.Categories.Remove(category);

            await _context.SaveChangesAsync(cancellationToken);

            _logger.LogInformation("Category deleted successfully. ID: {CategoryId}, Name: {CategoryName}, UserId: {UserId}",
                category.Id, category.Name, category.UserId);

            return Unit.Value;
        }
    }
}