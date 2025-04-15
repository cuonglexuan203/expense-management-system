using AutoMapper;
using EMS.Application.Common.Attributes;
using EMS.Application.Common.Extensions;
using EMS.Application.Common.Interfaces.DbContext;
using EMS.Application.Common.Utils;
using MediatR;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Logging;

namespace EMS.Application.Features.Onboarding.Queries.GetCurrencies
{
    [CacheableQuery(CacheKeyGenerator.GeneralKeys.Currencies)]
    public record GetCurrenciesQuery : IRequest<List<CurrencyDto>>;

    public class GetCurrenciesQueryHandler : IRequestHandler<GetCurrenciesQuery, List<CurrencyDto>>
    {
        private readonly ILogger<GetCurrenciesQueryHandler> _logger;
        private readonly IApplicationDbContext _context;
        private readonly IMapper _mapper;

        public GetCurrenciesQueryHandler(
            ILogger<GetCurrenciesQueryHandler> logger,
            IApplicationDbContext context,
            IMapper mapper)
        {
            _logger = logger;
            _context = context;
            _mapper = mapper;
        }
        public async Task<List<CurrencyDto>> Handle(GetCurrenciesQuery request, CancellationToken cancellationToken)
        {
            var currencyDtos = await _context.Currencies
                .AsNoTracking()
                .ProjectToListAsync<CurrencyDto>(_mapper.ConfigurationProvider);

            return currencyDtos;
        }
    }
}
