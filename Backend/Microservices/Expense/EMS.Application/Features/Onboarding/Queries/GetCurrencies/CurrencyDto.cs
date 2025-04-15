using EMS.Application.Common.Mappings;
using EMS.Core.Enums;
using EMS.Core.ValueObjects;

namespace EMS.Application.Features.Onboarding.Queries.GetCurrencies
{
    public class CurrencyDto : IMapFrom<Currency>
    {
        public CurrencyCode Code { get; set; }
        public string Country { get; set; } = default!;
        public string CurrencyName { get; set; } = default!;
    }
}
