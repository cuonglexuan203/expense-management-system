using AutoMapper;
using EMS.Application.Common.Interfaces.DbContext;
using MediatR;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Logging;

namespace EMS.Application.Features.Developer.Queries
{
    public record GetSystemSettingsQuery : IRequest<List<SystemSettingDto>>;

    public class GetSystemSettingsQueryHandler : IRequestHandler<GetSystemSettingsQuery, List<SystemSettingDto>>
    {
        private readonly IApplicationDbContext _context;
        private readonly IMapper _mapper;

        public GetSystemSettingsQueryHandler(ILogger<GetSystemSettingsQueryHandler> logger, IApplicationDbContext context, IMapper mapper)
        {
            _context = context;
            _mapper = mapper;
        }
        public async Task<List<SystemSettingDto>> Handle(GetSystemSettingsQuery request, CancellationToken cancellationToken)
        {
            return await _mapper.ProjectTo<SystemSettingDto>(_context.SystemSettings.Where(e => !e.IsDeleted)).ToListAsync();
        }
    }
}
