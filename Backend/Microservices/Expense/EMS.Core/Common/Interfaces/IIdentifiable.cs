namespace EMS.Core.Common.Interfaces
{
    public interface IIdentifiable<TKey>
    {
        TKey Id { get; set; }
    }
}
