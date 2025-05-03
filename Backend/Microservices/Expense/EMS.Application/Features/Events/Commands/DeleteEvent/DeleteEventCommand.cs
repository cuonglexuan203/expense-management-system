using EMS.Application.Common.Exceptions;
using EMS.Application.Common.Interfaces.DbContext;
using EMS.Application.Common.Interfaces.Services;
using EMS.Application.Common.Models;
using EMS.Core.Enums;
using MediatR;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Logging;

namespace EMS.Application.Features.Events.Commands.DeleteEvent
{
    // BUG: Events in status Processing/Queued can still run
    public record DeleteEventCommand(int Id) : IRequest<Result>;

    public class DeleteEventCommandHandler : IRequestHandler<DeleteEventCommand, Result>
    {
        private readonly ILogger<DeleteEventCommandHandler> _logger;
        private readonly IApplicationDbContext _context;
        private readonly ICurrentUserService _user;

        public DeleteEventCommandHandler(
            ILogger<DeleteEventCommandHandler> logger,
            IApplicationDbContext context,
            ICurrentUserService user)
        {
            _logger = logger;
            _context = context;
            _user = user;
        }
        public async Task<Result> Handle(DeleteEventCommand request, CancellationToken cancellationToken)
        {
            var userId = _user.Id;

            var evt = await _context.ScheduledEvents
                .Where(e => !e.IsDeleted && e.UserId == userId && e.Id == request.Id)
                .FirstOrDefaultAsync() ?? throw new NotFoundException($"Event {request.Id} not found");

            if (evt.Status == EventStatus.Completed)
            {
                throw new InvalidOperationException($"Can not delete the ended event");
            }

            _context.ScheduledEvents.Remove(evt);
            await _context.SaveChangesAsync();

            _logger.LogInformation("Deleted the event {EventId}", request.Id);

            return Result.Success();
        }
    }
}
