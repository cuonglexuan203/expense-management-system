using AutoMapper;
using EMS.Application.Common.Extensions;
using EMS.Application.Common.Interfaces.DbContext;
using EMS.Application.Common.Interfaces.Services;
using EMS.Application.Common.Models;
using EMS.Application.Features.Notifications.Dtos;
using EMS.Core.Enums;
using EMS.Core.Specifications;
using MediatR;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Logging;

namespace EMS.Application.Features.Notifications.Queries.GetNotifications
{
    public record GetNotificationsQuery(NotificationSpecParams SpecParams) : IRequest<PaginatedList<NotificationDto>>;

    public class GetNotificationsQueryHandler : IRequestHandler<GetNotificationsQuery, PaginatedList<NotificationDto>>
    {
        private readonly ILogger<GetNotificationsQueryHandler> _logger;
        private readonly IApplicationDbContext _context;
        private readonly IMapper _mapper;
        private readonly ICurrentUserService _user;

        public GetNotificationsQueryHandler(
            ILogger<GetNotificationsQueryHandler> logger,
            IApplicationDbContext context,
            IMapper mapper,
            ICurrentUserService user)
        {
            _logger = logger;
            _context = context;
            _mapper = mapper;
            _user = user;
        }
        public async Task<PaginatedList<NotificationDto>> Handle(GetNotificationsQuery request, CancellationToken cancellationToken)
        {
            var userId = _user.Id;
            var specParams = request.SpecParams;

            var query = _context.Notifications
                .Where(e => !e.IsDeleted && e.UserId == userId)
                .AsNoTracking();

            if(specParams.Id != null)
            {
                query = query.Where(e => e.Id == specParams.Id);
            }

            if (specParams.Type != null)
            {
                query = query.Where(e => e.Type == specParams.Type);
            }

            if (!string.IsNullOrEmpty(specParams.Text))
            {
                query = query.
                    Where(e =>
                        DatabaseFunctions.Unaccent(e.Title.ToLower()).
                            Contains(DatabaseFunctions.Unaccent(specParams.Text.ToLower())) ||
                        DatabaseFunctions.Unaccent(e.Body.ToLower()).
                            Contains(DatabaseFunctions.Unaccent(specParams.Text.ToLower())));
            }

            if (!string.IsNullOrEmpty(specParams.Title))
            {
                query = query.
                    Where(e => 
                        DatabaseFunctions.Unaccent(e.Title.ToLower()).
                            Contains(DatabaseFunctions.Unaccent(specParams.Title.ToLower())));
            }

            if (!string.IsNullOrEmpty(specParams.Body))
            {
                query = query.
                    Where(e =>
                        DatabaseFunctions.Unaccent(e.Body.ToLower())
                            .Contains(DatabaseFunctions.Unaccent(specParams.Body.ToLower())));
            }

            if (specParams.Status != null)
            {
                query = query.Where(e => e.Status == specParams.Status);
            }

            if (specParams.Since != null)
            {
                query = query.Where(e => e.ProcessedAt >= specParams.Since);
            }

            if (specParams.Until != null)
            {
                query = query.Where(e => e.ProcessedAt <= specParams.Until);
            }

            if (specParams.Sort == SortDirection.ASC)
            {
                query = query.
                    OrderBy(e => e.ProcessedAt).
                    ThenBy(e => e.CreatedAt);
            }
            else
            {
                query = query.
                    OrderByDescending(e  => e.ProcessedAt).
                    ThenByDescending(e => e.CreatedAt);
            }

            var dtoQuery = _mapper.ProjectTo<NotificationDto>(query);

            var result = await dtoQuery.ToPaginatedList(specParams.PageNumber, specParams.PageSize);

            return result;
        }
    }
}
