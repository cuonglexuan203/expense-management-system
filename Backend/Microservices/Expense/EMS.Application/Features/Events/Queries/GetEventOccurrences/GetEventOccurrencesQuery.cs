using AutoMapper;
using AutoMapper.QueryableExtensions;
using EMS.Application.Common.Interfaces.DbContext;
using EMS.Application.Common.Interfaces.Services;
using EMS.Application.Features.Events.Dtos;
using EMS.Core.Entities;
using MediatR;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Logging;

namespace EMS.Application.Features.Events.Queries.GetEventOccurrences
{
    // OPTIMIZE: Cache the event occurrences
    public record GetEventOccurrencesQuery(
        DateTimeOffset FromUtc,
        DateTimeOffset ToUtc) : IRequest<List<EventOccurrenceDto>>;

    public class GetEventOccurrencesQueryHandler : IRequestHandler<GetEventOccurrencesQuery, List<EventOccurrenceDto>>
    {
        private readonly ILogger<GetEventOccurrencesQueryHandler> _logger;
        private readonly IApplicationDbContext _context;
        private readonly IEventSchedulerService _eventSchedulerService;
        private readonly ICurrentUserService _user;
        private readonly IUserPreferenceService _userPreferenceService;
        private readonly IMapper _mapper;

        public GetEventOccurrencesQueryHandler(
            ILogger<GetEventOccurrencesQueryHandler> logger,
            IApplicationDbContext context,
            IEventSchedulerService eventSchedulerService,
            ICurrentUserService user,
            IUserPreferenceService userPreferenceService,
            IMapper mapper)
        {
            _logger = logger;
            _context = context;
            _eventSchedulerService = eventSchedulerService;
            _user = user;
            _userPreferenceService = userPreferenceService;
            _mapper = mapper;
        }

        public async Task<List<EventOccurrenceDto>> Handle(GetEventOccurrencesQuery request, CancellationToken cancellationToken)
        {
            var userId = _user.Id!;
            var start = request.FromUtc;
            var end = request.ToUtc;
            var timeZoneId = (await _userPreferenceService.GetTimeZoneIdAsync(userId))!;

            var relevantEventQuery = _context.ScheduledEvents
                .Include(e => e.RecurrenceRule)
                .Where(e => !e.IsDeleted && e.UserId == userId)
                .Where(e =>
                    (e.RecurrenceRuleId == null &&
                        e.InitialTrigger >= start &&
                        e.InitialTrigger <= end) ||
                    (e.RecurrenceRuleId != null && (
                        e.InitialTrigger <= end &&
                        (e.RecurrenceRule!.EndDate == null || e.RecurrenceRule!.EndDate >= start)
                    )))
                .OrderBy(e => e.InitialTrigger);

            var relevantEvents = await relevantEventQuery.ToListAsync();

            var result = new List<EventOccurrenceDto>();
            foreach (var evt in relevantEvents)
            {
                var occurrenceTimes = await _eventSchedulerService.CalculateOccurrencesAsync(evt, start, end, timeZoneId);
                
                foreach (var occurrenceTime in occurrenceTimes)
                {
                    result.Add(await CreateOccurrence(evt, occurrenceTime));
                }
            }

            result = result
                .OrderByDescending(e => e.ScheduledTime)
                .ThenBy(e => e.Name)
                .ToList();

            return result;
        }

        private async Task<EventOccurrenceDto> CreateOccurrence(ScheduledEvent scheduledEvent, DateTimeOffset startAt)
        {
            var executionLog = await _context.ScheduledEventExecutions
                .Where(e => !e.IsDeleted && 
                    e.ScheduledEventId == scheduledEvent.Id &&
                    e.ScheduledTime == startAt)
                .ProjectTo<ScheduledEventExecutionDto>(_mapper.ConfigurationProvider)
                .OrderByDescending(e => e.CreatedAt)
                .FirstOrDefaultAsync();

            var occurrence = EventOccurrenceDto.CreateFrom(
                _mapper.Map<ScheduledEventDto>(scheduledEvent),
                startAt,
                executionLog);

            return occurrence;
        }
    }
}
