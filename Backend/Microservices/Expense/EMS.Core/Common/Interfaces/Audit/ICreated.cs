namespace EMS.Core.Common.Interfaces.Audit
{
    public interface ICreated
    {
        DateTimeOffset? CreatedAt { get; set; }
        Guid? CreatedBy { get; set; }
    }
}
