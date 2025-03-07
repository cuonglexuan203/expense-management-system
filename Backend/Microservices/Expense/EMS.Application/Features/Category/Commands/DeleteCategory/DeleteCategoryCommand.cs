using EMS.Application.Common.Exceptions;
using EMS.Application.Common.Interfaces.DbContext;
using EMS.Application.Common.Interfaces.Services;
using MediatR;
using Microsoft.EntityFrameworkCore;
using System;

namespace EMS.Application.Features.Category.Commands.DeleteCategory
{
    public record DeleteCategoryCommand(int Id) : IRequest<Unit>;

    public class DeleteCategoryCommandHandler : IRequestHandler<DeleteCategoryCommand, Unit>
    {
        private readonly IApplicationDbContext _context;
        private readonly ICurrentUserService _currentUserService;

        public DeleteCategoryCommandHandler(IApplicationDbContext context, ICurrentUserService currentUserService)
        {
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

            // Check if the category has transactions
            if (category.Transactions.Any())
            {
                throw new InvalidOperationException("Cannot delete a category that has transactions. Please remove or reassign the transactions first.");
            }

            // Soft delete
            category.IsDeleted = true;
            category.DeletedAt = DateTimeOffset.UtcNow;
            category.DeletedBy = userId;

            await _context.SaveChangesAsync(cancellationToken);

            return Unit.Value;
        }
    }
}