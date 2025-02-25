using EMS.Core.Entities.Common;

namespace EMS.Core.Entities
{
    public class RefreshToken : BaseAuditableEntity<Guid>
    {
        public string UserId { get; set; } = default!;
        public string Token { get; set; } = default!;
        public DateTimeOffset Expires { get; set; }
        public DateTimeOffset? Revoked { get; set; }
        public bool IsActive => Revoked == null && Expires > DateTimeOffset.UtcNow;

        #region Navigations
        public virtual IUser<string> User { get; set; } = default!;
        #endregion
    }
}
