using EMS.Application.Common.Mappings;
using EMS.Core.Entities;

namespace EMS.Application.Features.Profiles.Dtos
{
    public class UserDto : IMapFrom<IUser<string>>
    {
        public string Id { get; set; } = default!;
        public string? FullName { get; set; }
        public string? Avatar { get; set; }
        public string? Email { get; set; }
        public string? UserName { get; set; }
        public DateTimeOffset? CreatedAt { get; set; }

        public UserDto()
        {
            
        }

        public UserDto(string? fullName, string? avatar, string? email)
        {
            FullName = fullName;
            Avatar = avatar;
            Email = email;
        }
    }
}
