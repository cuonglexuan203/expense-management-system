using AutoMapper;
using EMS.Application.Common.Extensions;
using EMS.Application.Common.Interfaces.DbContext;
using EMS.Application.Common.Interfaces.Services;
using EMS.Application.Common.Models;
using EMS.Application.Features.Events.Dtos;
using EMS.Core.Enums;
using EMS.Core.Specifications;
using MediatR;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Logging;

namespace EMS.Application.Features.Events.Queries.GetScheduledEvents
{
    public record GetScheduledEventsQuery(ScheduledEventSpecParams SpecParams) : IRequest<PaginatedList<ScheduledEventDto>>;

    public class GetScheduledEventsQueryHandler : IRequestHandler<GetScheduledEventsQuery, PaginatedList<ScheduledEventDto>>
    {
        private readonly ILogger<GetScheduledEventsQueryHandler> _logger;
        private readonly ICurrentUserService _user;
        private readonly IApplicationDbContext _context;
        private readonly IMapper _mapper;

        public GetScheduledEventsQueryHandler(
            ILogger<GetScheduledEventsQueryHandler> logger,
            ICurrentUserService user,
            IApplicationDbContext context,
            IMapper mapper)
        {
            _logger = logger;
            _user = user;
            _context = context;
            _mapper = mapper;
        }
        public async Task<PaginatedList<ScheduledEventDto>> Handle(GetScheduledEventsQuery request, CancellationToken cancellationToken)
        {
            var specParams = request.SpecParams;
            var userId = _user.Id!;

            var query = _context.ScheduledEvents
                .AsNoTracking()
                .Include(e => e.RecurrenceRule)
                .Where(e => !e.IsDeleted
                && e.UserId == userId);

            if (specParams.NextOccurrenceFrom.HasValue)
            {
                query = query.Where(e => e.NextOccurrence >= specParams.NextOccurrenceFrom.Value);
            }

            if (specParams.NextOccurrenceTo.HasValue)
            {
                query = query.Where(e => e.NextOccurrence <= specParams.NextOccurrenceTo.Value);
            }

            if (specParams.LastOccurrenceFrom.HasValue)
            {
                query = query.Where(e => e.LastOccurrence >= specParams.LastOccurrenceFrom.Value);
            }

            if (specParams.LastOccurrenceTo.HasValue)
            {
                query = query.Where(e => e.LastOccurrence <= specParams.LastOccurrenceTo.Value);
            }

            if (specParams.Type.HasValue)
            {
                query = query.Where(e => e.Type == specParams.Type.Value);
            }

            if (!string.IsNullOrEmpty(specParams.Text))
            {
                query = query.Where(e =>
                    DatabaseFunctions.Unaccent(e.Name.ToLower())
                        .Contains(DatabaseFunctions.Unaccent(specParams.Text.ToLower())) ||
                    (e.Description != null &&
                    DatabaseFunctions.Unaccent(e.Description.ToLower())
                        .Contains(DatabaseFunctions.Unaccent(specParams.Text.ToLower()))));
            }

            if (!string.IsNullOrEmpty(specParams.Name))
            {
                query = query.Where(e =>
                    DatabaseFunctions.Unaccent(e.Name.ToLower())
                        .Contains(DatabaseFunctions.Unaccent(specParams.Name.ToLower())));
            }

            if (!string.IsNullOrEmpty(specParams.Description))
            {
                query = query.Where(e => e.Description != null &&
                    DatabaseFunctions.Unaccent(e.Description.ToLower())
                        .Contains(DatabaseFunctions.Unaccent(specParams.Description.ToLower())));
            }

            if (specParams.Status.HasValue)
            {
                query = query.Where(e => e.Status == specParams.Status.Value);
            }

            if (specParams.SortByNextOccurrence.HasValue && specParams.SortByNextOccurrence.Value == true)
            {
                if (specParams.Sort == SortDirection.ASC)
                {
                    query = query.OrderBy(e => e.NextOccurrence);
                }
                else
                {
                    query = query.OrderByDescending(e => e.NextOccurrence);
                }
            }
            else
            {
                if (specParams.Sort == SortDirection.ASC)
                {
                    query = query.OrderBy(e => e.CreatedAt);
                }
                else
                {
                    query = query.OrderByDescending(e => e.CreatedAt);
                }
            }
            

            var dtoQuery = _mapper.ProjectTo<ScheduledEventDto>(query);

            var result = await dtoQuery.ToPaginatedList(specParams.PageNumber, specParams.PageSize);

            return result;
        }
    }
}
