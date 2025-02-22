using EMS.Core.Common.Interfaces;

namespace EMS.Core.Entities.Common
{
    public class BaseEntity<TKey> : IIdentifiable<TKey>
    {
        public TKey Id { get; set; } = default!;
    }
}
