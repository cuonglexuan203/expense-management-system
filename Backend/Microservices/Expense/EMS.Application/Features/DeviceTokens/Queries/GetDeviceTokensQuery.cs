using EMS.Application.Common.Interfaces.DbContext;
using MediatR;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Logging;

namespace EMS.Application.Features.DeviceTokens.Queries
{
    public record GetDeviceTokensQuery(string UserId) : IRequest<List<string>>;

    public class GetDeviceTokensQueryHandler : IRequestHandler<GetDeviceTokensQuery, List<string>>
    {
        private readonly ILogger<GetDeviceTokensQueryHandler> _logger;
        private readonly IApplicationDbContext _context;

        public GetDeviceTokensQueryHandler(
            ILogger<GetDeviceTokensQueryHandler> logger,
            IApplicationDbContext context)
        {
            _logger = logger;
            _context = context;
        }
        public async Task<List<string>> Handle(GetDeviceTokensQuery request, CancellationToken cancellationToken)
        {
            var deviceTokens = await _context.DeviceTokens
                .Where(e => !e.IsDeleted
                    && e.IsActive
                    && e.UserId == request.UserId)
                .Select(e => e.Token)
                .ToListAsync();

            return deviceTokens;
        }
    }
}
