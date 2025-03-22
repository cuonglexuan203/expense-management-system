using EMS.Application.Common.Models;
using System.Data;

namespace EMS.Application.Common.Interfaces.Services
{
    public interface IDatabaseTransactionManager
    {
        Task ExecuteInTransactionAsync(Func<Task> operation, IsolationLevel isolationLevel = IsolationLevel.ReadCommitted);
        Task<TResult> ExecuteInTransactionAsync<TResult>(Func<Task<TResult>> operation, IsolationLevel isolationLevel = IsolationLevel.ReadCommitted);
        Task ExecuteWithResilienceAsync(Func<Task> operation);
        Task<TResult> ExecuteWithResilienceAsync<TResult>(Func<Task<TResult>> operation);
        Task ExecuteWithResilienceAsync(Func<Task> operation, IsolationLevel isolationLevel);
        Task<TResult> ExecuteWithResilienceAsync<TResult>(Func<Task<TResult>> operation, IsolationLevel isolationLevel);

    }
}
