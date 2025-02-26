using Microsoft.AspNetCore.Identity;

namespace EMS.Infrastructure.Identity.Models
{
    public class ApplicationRole : IdentityRole
    {
        public ApplicationRole(string roleName) : base(roleName)
        {

        }
    }
}
