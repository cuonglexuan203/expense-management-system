using EMS.Core.Common.Interfaces;

namespace EMS.Core.Entities.Common
{
    public class BaseEntity<TKey> : AuditableEntity, IIdentifiable<TKey>
    {
        public TKey Id { get; set; } = default!;
    }
}
