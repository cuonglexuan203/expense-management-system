using AutoMapper;
using EMS.Application.Common.Interfaces.DbContext;
using EMS.Application.Common.Interfaces.Services;
using EMS.Application.Features.Events.Dtos;
using EMS.Core.Entities;
using EMS.Core.Enums;
using MediatR;
using Microsoft.Extensions.Logging;

namespace EMS.Application.Features.Events.Commands.ScheduleEvent
{
    public record ScheduleEventCommand(
        string Name,
        string? Description,
        EventType Type,
        string? Payload,
        DateTimeOffset InitialTriggerDateTime,
        RecurrenceRuleRequest? Rule) : IRequest<ScheduledEventDto>;

    public class ScheduleEventCommandHandler : IRequestHandler<ScheduleEventCommand, ScheduledEventDto>
    {
        private readonly ILogger<ScheduleEventCommandHandler> _logger;
        private readonly IApplicationDbContext _context;
        private readonly ICurrentUserService _user;
        private readonly IMapper _mapper;

        public ScheduleEventCommandHandler(
            ILogger<ScheduleEventCommandHandler> logger,
            IApplicationDbContext context,
            ICurrentUserService user,
            IMapper mapper)
        {
            _logger = logger;
            _context = context;
            _user = user;
            _mapper = mapper;
        }

        public async Task<ScheduledEventDto> Handle(ScheduleEventCommand request, CancellationToken cancellationToken)
        {
            var userId = _user.Id!;

            var scheduledEvent = new ScheduledEvent
            {
                UserId = userId,
                Name = request.Name,
                Description = request.Description,
                Type = request.Type,
                Payload = request.Payload,
                Status = EventStatus.Active,
                InitialTrigger = request.InitialTriggerDateTime,
                NextOccurrence = request.InitialTriggerDateTime,
            };

            if (request.Rule != null)
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

                scheduledEvent.RecurrenceRule = rule;
            }

            _context.ScheduledEvents.Add(scheduledEvent);
            await _context.SaveChangesAsync();

            return _mapper.Map<ScheduledEventDto>(scheduledEvent);
        }
    }
}
