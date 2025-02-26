using EMS.Core.Common.Interfaces.Audit;

namespace EMS.Core.Entities.Common
{
    public class BaseAuditableEntity<TKey> : BaseEntity<TKey>, IAuditableEntity
    {
        public virtual DateTimeOffset? CreatedAt { get; set; }
        public virtual string? CreatedBy { get; set; }
        public virtual DateTimeOffset? ModifiedAt { get; set; }
        public virtual string? ModifiedBy { get; set; }
        public virtual bool IsDeleted { get; set; }
        public virtual DateTimeOffset? DeletedAt { get; set; }
        public virtual string? DeletedBy { get; set; }
    }
}
