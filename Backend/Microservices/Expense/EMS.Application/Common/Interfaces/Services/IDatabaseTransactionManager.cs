using System.Data;

namespace EMS.Application.Common.Interfaces.Services
{
    public interface IDatabaseTransactionManager
    {
        Task ExecuteInTransactionAsync(
            Func<Task> operation,
            bool clearChangeTrackerOnRollback = false,
            IsolationLevel isolationLevel = IsolationLevel.ReadCommitted);
        Task<TResult> ExecuteInTransactionAsync<TResult>(
            Func<Task<TResult>> operation,
            bool clearChangeTrackerOnRollback = false,
            IsolationLevel isolationLevel = IsolationLevel.ReadCommitted);
    }
}
