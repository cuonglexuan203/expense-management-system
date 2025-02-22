namespace EMS.Application.Common.Interfaces.Services
{
    public interface IUser
    {
        string? Id { get; }
        string? IpAddress { get; }
        string? UserAgent { get; }
    }
}
