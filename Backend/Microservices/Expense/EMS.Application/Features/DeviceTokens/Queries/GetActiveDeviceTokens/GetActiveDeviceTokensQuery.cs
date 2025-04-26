using EMS.Application.Common.Interfaces.DbContext;
using MediatR;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Logging;

namespace EMS.Application.Features.DeviceTokens.Queries.GetActiveDeviceTokens
{
    public record GetActiveDeviceTokensQuery(string UserId) : IRequest<List<string>>;

    public class GetActiveDeviceTokensQueryHandler : IRequestHandler<GetActiveDeviceTokensQuery, List<string>>
    {
        private readonly ILogger<GetActiveDeviceTokensQueryHandler> _logger;
        private readonly IApplicationDbContext _context;

        public GetActiveDeviceTokensQueryHandler(
            ILogger<GetActiveDeviceTokensQueryHandler> logger,
            IApplicationDbContext context)
        {
            _logger = logger;
            _context = context;
        }
        public async Task<List<string>> Handle(GetActiveDeviceTokensQuery request, CancellationToken cancellationToken)
        {
            var deviceTokens = await _context.DeviceTokens
                .AsNoTracking()
                .Where(e => !e.IsDeleted
                    && e.IsActive
                    && e.UserId == request.UserId)
                .Select(e => e.Token)
                .ToListAsync();

            return deviceTokens;
        }
    }
}
