namespace EMS.Core.Common.Interfaces.Audit
{
    public interface IModified
    {
        DateTimeOffset? ModifiedAt { get; set; }
        string? ModifiedBy { get; set; }
    }
}
