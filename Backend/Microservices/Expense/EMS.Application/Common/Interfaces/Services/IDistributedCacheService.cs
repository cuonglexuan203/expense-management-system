namespace EMS.Application.Common.Interfaces.Services
{
    public interface IDistributedCacheService
    {
        Task<T?> GetAsync<T>(string key, CancellationToken cancellationToken = default);
        Task SetAsync<T>(string key, T value, TimeSpan? expiryTime = null, CancellationToken cancellationToken = default);
        Task RemoveAsync(string key, CancellationToken cancellationToken = default);
        Task<T> GetOrSetAsync<T>(string key, Func<Task<T>> factory, TimeSpan? expiryTime = null, CancellationToken cancellationToken = default);
        Task<bool> KeyExistsAsync(string key, CancellationToken cancellationToken = default);
        Task<bool> RefreshAsync(string key, CancellationToken cancellationToken = default);
    }
}
