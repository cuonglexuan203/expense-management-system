using EMS.Core.Entities.Common;
using EMS.Core.Enums;
using EMS.Core.ValueObjects;

namespace EMS.Core.Entities
{
    public class CurrencySlang : BaseAuditableEntity<int>
    {
        public CurrencyCode CurrencyCode { get; set; } = CurrencyCode.USD;
        public string SlangTerm { get; set; } = default!;
        public float Multiplier { get; set; }
        public string? Description { get; set; }

        // Navigations
        public Currency Currency { get; set; } = default!;
    }
}
