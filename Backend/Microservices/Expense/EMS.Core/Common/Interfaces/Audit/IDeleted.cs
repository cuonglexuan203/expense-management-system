namespace EMS.Core.Common.Interfaces.Audit
{
    public interface IDeleted
    {
        bool IsDeleted { get; set; }
        DateTimeOffset? DeletedAt { get; set; }
        string? DeletedBy { get; set; }
    }
}
