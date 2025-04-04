using EMS.Core.Entities.Common;

namespace EMS.Core.Entities
{
    public class ApiKeyScope : BaseAuditableEntity<int>
    {
        public string Scope { get; private set; } = default!;

        // Navigations
        public ICollection<ApiKey> ApiKeys { get; private set; } = [];

        private ApiKeyScope() { }

        public ApiKeyScope(string scope)
        {
            Scope = scope ?? throw new ArgumentNullException(nameof(scope));
        }
    }
}
