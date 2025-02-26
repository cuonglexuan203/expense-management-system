using Microsoft.AspNetCore.Identity;

namespace EMS.Infrastructure.Identity.Models
{
    public class ApplicationRole : IdentityRole
    {
        public ApplicationRole()
        {
            
        }

        public ApplicationRole(string roleName) : base(roleName)
        {

        }
    }
}
