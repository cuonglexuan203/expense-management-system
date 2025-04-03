using AutoMapper;
using EMS.Application.Common.Extensions;
using EMS.Application.Common.Interfaces.DbContext;
using EMS.Core.Enums;
using MediatR;
using Microsoft.Extensions.Logging;

namespace EMS.Application.Features.CurrencySlangs.Queries.GetCurrencySlangs
{
    public record GetCurrencySlangsQuery(CurrencyCode CurrencyCode) : IRequest<List<CurrencySlangDto>>;

    public class GetCurrencySlangsQueryHandler : IRequestHandler<GetCurrencySlangsQuery, List<CurrencySlangDto>>
    {
        private readonly ILogger<GetCurrencySlangsQueryHandler> _logger;
        private readonly IApplicationDbContext _context;
        private readonly IMapper _mapper;

        public GetCurrencySlangsQueryHandler(
            ILogger<GetCurrencySlangsQueryHandler> logger,
            IApplicationDbContext context,
            IMapper mapper)
        {
            _logger = logger;
            _context = context;
            _mapper = mapper;
        }
        public async Task<List<CurrencySlangDto>> Handle(GetCurrencySlangsQuery request, CancellationToken cancellationToken)
        {
            var currencySlangDtoList = await _context.CurrencySlangs
                .Where(e => !e.IsDeleted && e.CurrencyCode == request.CurrencyCode)
                .OrderBy(e => e.SlangTerm)
                .ProjectToListAsync<CurrencySlangDto>(_mapper.ConfigurationProvider);

            return currencySlangDtoList;
        }
    }
}
