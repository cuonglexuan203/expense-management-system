using AutoMapper;
using EMS.Application.Common.Exceptions;
using EMS.Application.Common.Interfaces.DbContext;
using EMS.Application.Common.Interfaces.Services;
using EMS.Application.Features.Events.Dtos;
using EMS.Core.Entities;
using EMS.Core.Enums;
using MediatR;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Logging;

namespace EMS.Application.Features.Events.Commands.UpdateEvent
{
    // BUG: Events do not change in status: Processing / Queued
    public record UpdateEventCommand(
        int Id,
        string? Name,
        string? Description,
        string? Payload,
        DateTimeOffset? InitialTriggerDateTime,
        RecurrenceRuleRequest? Rule) : IRequest<ScheduledEventDto>;

    public class UpdateEventCommandHandler : IRequestHandler<UpdateEventCommand, ScheduledEventDto>
    {
        private readonly ILogger<UpdateEventCommandHandler> _logger;
        private readonly IApplicationDbContext _context;
        private readonly IMapper _mapper;
        private readonly ICurrentUserService _user;

        public UpdateEventCommandHandler(
            ILogger<UpdateEventCommandHandler> logger,
            IApplicationDbContext context,
            IMapper mapper,
            ICurrentUserService user)
        {
            _logger = logger;
            _context = context;
            _mapper = mapper;
            _user = user;
        }
        public async Task<ScheduledEventDto> Handle(UpdateEventCommand request, CancellationToken cancellationToken)
        {
            var userId = _user.Id;

            var evt = await _context.ScheduledEvents
                .Include(e => e.RecurrenceRule)
                .Where(e => !e.IsDeleted && e.UserId == userId && e.Id == request.Id)
                .FirstOrDefaultAsync() ?? throw new NotFoundException($"Event with ID {request.Id} not found");

            if (evt.Status == EventStatus.Completed)
            {
                throw new InvalidOperationException($"The event ID {request.Id} ended");
            }

            if (!string.IsNullOrEmpty(request.Name))
            {
                evt.Name = request.Name;
            }

            if (!string.IsNullOrEmpty(request.Description))
            {
                evt.Description = request.Description;
            }

            if (!string.IsNullOrEmpty(request.Payload))
            {
                evt.Payload = request.Payload;
            }

            if (request.InitialTriggerDateTime.HasValue)
            {
                evt.InitialTrigger = request.InitialTriggerDateTime.Value;
                evt.NextOccurrence = request.InitialTriggerDateTime.Value;
            }

            if (request.Rule != null)
            {
                if (evt.RecurrenceRule != null)
                {
                    evt.RecurrenceRule.Frequency = request.Rule.Frequency;

                    if (request.Rule.Interval.HasValue)
                    {
                        evt.RecurrenceRule.Interval = request.Rule.Interval.Value;
                    }

                    if (request.Rule.ByDayOfWeek != null)
                    {
                        evt.RecurrenceRule.ByDayOfWeek = request.Rule.ByDayOfWeek;
                    }

                    if (request.Rule.ByMonthDay != null)
                    {
                        evt.RecurrenceRule.ByMonthDay = request.Rule.ByMonthDay;
                    }

                    if (request.Rule.ByMonth != null)
                    {
                        evt.RecurrenceRule.ByMonth = request.Rule.ByMonth;
                    }

                    if (request.Rule.EndDate.HasValue)
                    {
                        evt.RecurrenceRule.EndDate = request.Rule.EndDate.Value;
                    }

                    if (request.Rule.MaxOccurrences.HasValue)
                    {
                        evt.RecurrenceRule.MaxOccurrences = request.Rule.MaxOccurrences.Value;
                    }
                }
                else
                {
                    var rule = new RecurrenceRule
                    {
                        Frequency = request.Rule.Frequency,
                    };

                    if (request.Rule.Interval.HasValue)
                    {
                        rule.Interval = request.Rule.Interval.Value;
                    }

                    if (request.Rule.ByDayOfWeek != null)
                    {
                        rule.ByDayOfWeek = request.Rule.ByDayOfWeek;
                    }

                    if (request.Rule.ByMonthDay != null)
                    {
                        rule.ByMonthDay = request.Rule.ByMonthDay;
                    }

                    if (request.Rule.ByMonth != null)
                    {
                        rule.ByMonth = request.Rule.ByMonth;
                    }

                    if (request.Rule.EndDate.HasValue)
                    {
                        rule.EndDate = request.Rule.EndDate.Value;
                    }

                    if (request.Rule.MaxOccurrences.HasValue)
                    {
                        rule.MaxOccurrences = request.Rule.MaxOccurrences.Value;
                    }

                    evt.RecurrenceRule = rule;
                }
            }

            _context.ScheduledEvents.Update(evt);
            await _context.SaveChangesAsync();

            _logger.LogInformation("Update Event {EventId} successfully", request.Id);
            
            return _mapper.Map<ScheduledEventDto>(evt);
        }
    }
}
