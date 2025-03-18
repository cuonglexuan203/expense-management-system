using EMS.Core.Enums;
using EMS.Core.ValueObjects.Common;

namespace EMS.Core.ValueObjects
{
    public class CurrencyCode : ValueObject
    {
        public Currency Code { get; set; }
        public string Country { get; set; } = default!;
        public string CurrencyName { get; set; } = default!;

        protected override IEnumerable<object> GetEqualityComponents()
        {
            yield return Code;
            yield return Country;
            yield return CurrencyName;
        }
    }
}
