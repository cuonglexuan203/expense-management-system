using EMS.Core.Entities.Common;

namespace EMS.Core.Entities
{
    public class ApiKey : BaseAuditableEntity<Guid>
    {
        public string Key { get; private set; } = default!; // Hashed key
        public string Name { get; private set; } = default!;
        public string? Description { get; private set; }
        public string? OwnerId { get; private set; } // User/service that owns this key
        public DateTimeOffset? ExpiresAt { get; private set; }
        public DateTimeOffset? LastUsedAt { get; private set; }
        public bool IsActive { get; private set; }

        // Navigations
        public ICollection<ApiKeyScope> Scopes { get; private set; } = [];

        private ApiKey() { }

        public ApiKey(string name, string hashedKey, string ownerId, string? description = null, DateTimeOffset? expiresAt = null)
        {
            Id = Guid.NewGuid();
            Name = name ?? throw new ArgumentNullException(nameof(name));
            Key = hashedKey ?? throw new ArgumentNullException(nameof(hashedKey));
            OwnerId = ownerId;
            Description = description;
            ExpiresAt = expiresAt;
            IsActive = true;
        }

        #region Behaviors
        public void Deactivate()
        {
            IsActive = false;
        }

        public void UpdateLastUsed()
        {
            LastUsedAt = DateTimeOffset.UtcNow;
        }

        public bool IsValid()
        {
            return IsActive && (ExpiresAt == null || ExpiresAt > DateTimeOffset.UtcNow);
        }

        public void AddScope(ApiKeyScope scope)
        {
            if (scope == null) throw new ArgumentNullException(nameof(scope));

            Scopes.Add(scope);
        }

        public void RemoveScope(ApiKeyScope scope)
        {
            if (scope == null) throw new ArgumentNullException(nameof(scope));

            Scopes.Remove(scope);
        }

        public bool HasScope(string scope)
        {
            return Scopes.Any(s => s.Scope.Equals(scope, StringComparison.OrdinalIgnoreCase));
        }
        #endregion
    }
}
