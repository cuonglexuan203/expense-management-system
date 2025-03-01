using EMS.Core.Common.Interfaces.Audit;
using Microsoft.AspNetCore.Identity;

namespace EMS.Infrastructure.Identity.Models
{
    public class ApplicationRole : IdentityRole, IAuditableEntity
    {
        public DateTimeOffset? CreatedAt { get; set; }
        public string? CreatedBy { get; set; }
        public DateTimeOffset? ModifiedAt { get; set; }
        public string? ModifiedBy { get; set; }
        public bool IsDeleted { get; set; }
        public DateTimeOffset? DeletedAt { get; set; }
        public string? DeletedBy { get; set; }

        public ApplicationRole()
        {
            
        }

        public ApplicationRole(string roleName) : base(roleName)
        {

        }
    }
}
