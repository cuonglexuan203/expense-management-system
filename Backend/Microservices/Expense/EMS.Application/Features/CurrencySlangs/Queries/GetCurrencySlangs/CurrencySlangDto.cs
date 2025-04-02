using EMS.Application.Common.Mappings;
using EMS.Core.Entities;
using EMS.Core.Enums;

namespace EMS.Application.Features.CurrencySlangs.Queries.GetCurrencySlangs
{
    public class CurrencySlangDto : IMapFrom<CurrencySlang>
    {
        public CurrencyCode CurrencyCode { get; set; }
        public string SlangTerm { get; set; } = default!;
        public float Multiplier { get; set; }
        public string? Description { get; set; }
    }
}
