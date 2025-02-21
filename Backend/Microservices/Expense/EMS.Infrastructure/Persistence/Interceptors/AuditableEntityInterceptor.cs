using EMS.Application.Common.Interfaces.Services;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.ChangeTracking;
using Microsoft.EntityFrameworkCore.Diagnostics;
using Microsoft.Extensions.Logging;

namespace EMS.Infrastructure.Persistence.Interceptors
{
    public class AuditableEntityInterceptor : SaveChangesInterceptor
    {
        private readonly ILogger<AuditableEntityInterceptor> _logger;
        private readonly IUser _user;
        private readonly TimeProvider _timeProvider;

        public AuditableEntityInterceptor(ILogger<AuditableEntityInterceptor> logger, IUser user, TimeProvider timeProvider)
        {
            _timeProvider = timeProvider;
            _logger = logger;
            _user = user;
            _timeProvider = timeProvider;
        }

        public override InterceptionResult<int> SavingChanges(DbContextEventData eventData, InterceptionResult<int> result)
        {
            UpdateEntities(eventData.Context);
            return base.SavingChanges(eventData, result);
        }

        public override ValueTask<InterceptionResult<int>> SavingChangesAsync(DbContextEventData eventData, InterceptionResult<int> result, CancellationToken cancellationToken = default)
        {
            UpdateEntities(eventData.Context);
            return base.SavingChangesAsync(eventData, result, cancellationToken);
        }

        private void UpdateEntities(Microsoft.EntityFrameworkCore.DbContext? context)
        {
            if (context == null)
            {
                return;
            }

        }

    }
}

public static class Extensions
{
    public static bool HasChangedOwnedEntity(this EntityEntry entry)
        => entry.References.Any(r =>
        r.TargetEntry != null &&
        r.TargetEntry.Metadata.IsOwned() &&
        (r.TargetEntry.State == EntityState.Added || r.TargetEntry.State == EntityState.Modified));
}