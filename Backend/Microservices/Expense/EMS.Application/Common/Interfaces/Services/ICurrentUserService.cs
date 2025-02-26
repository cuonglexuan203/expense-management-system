namespace EMS.Application.Common.Interfaces.Services
{
    public interface ICurrentUserService
    {
        string? Id { get; }
        string? IpAddress { get; }
        string? UserAgent { get; }
    }
}
