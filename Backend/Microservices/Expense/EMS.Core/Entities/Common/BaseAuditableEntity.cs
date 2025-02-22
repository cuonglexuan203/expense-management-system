using EMS.Core.Common.Interfaces.Audit;

namespace EMS.Core.Entities.Common
{
    public class BaseAuditableEntity<TKey> : BaseEntity<TKey>, IAuditableEntity
    {
        public DateTimeOffset? CreatedAt { get; set; }
        public string? CreatedBy { get; set; }
        public DateTimeOffset? ModifiedAt { get; set; }
        public string? ModifiedBy { get; set; }
        public bool IsDeleted { get; set; }
        public DateTimeOffset? DeletedAt { get; set; }
        public string? DeletedBy { get; set; }
    }
}
