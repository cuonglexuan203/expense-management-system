using EMS.Core.Common.Interfaces;
using EMS.Core.Common.Interfaces.Audit;

namespace EMS.Core.Entities
{
    public interface IUser<TKey> : IIdentifiable<TKey>, IAuditableEntity
    {
        string FullName { get; set; }
        string Avatar { get; set; }
        string? Email { get; set; }
    }
}
