using EMS.Core.Entities.Common;

namespace EMS.Core.Entities
{
    public class RefreshToken : BaseAuditableEntity<Guid>
    {
        public string UserId { get; set; } = default!;
        public string Token { get; set; } = default!;
        public DateTime ExpiresAt { get; set; }
        public DateTime? RevokeAt { get; set; }
        public bool IsActive => RevokeAt == null && ExpiresAt > DateTime.UtcNow;

        #region Navigations
        public virtual IUser<string> User { get; set; } = default!;
        #endregion

        public RefreshToken()
        {
            
        }

        public RefreshToken(string userId, string token, DateTime expiresAt)
        {
            UserId = userId;
            Token = token;
            ExpiresAt = expiresAt;
        }
    }
}
