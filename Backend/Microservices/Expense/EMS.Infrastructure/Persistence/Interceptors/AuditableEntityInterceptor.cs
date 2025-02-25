using EMS.Application.Common.Interfaces.Services;
using EMS.Application.Common.Models;
using EMS.Core.Common.Interfaces.Audit;
using EMS.Core.Entities;
using EMS.Core.Enums;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.ChangeTracking;
using Microsoft.EntityFrameworkCore.Diagnostics;

namespace EMS.Infrastructure.Persistence.Interceptors
{
    public class AuditableEntityInterceptor : SaveChangesInterceptor
    {
        private readonly ICurrentUserService _user;
        private readonly TimeProvider _timeProvider;

        public AuditableEntityInterceptor(ICurrentUserService user, TimeProvider timeProvider)
        {
            _timeProvider = timeProvider;
            _user = user;
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

            var auditEntries = new List<AuditEntry>();
            foreach (var entry in context.ChangeTracker.Entries())
            {
                if (entry.Entity is ActivityLog || entry.State is EntityState.Detached or EntityState.Unchanged)
                {
                    continue;
                }

                var utcNow = _timeProvider.GetUtcNow();

                if (entry.State is EntityState.Added or EntityState.Modified || entry.HasChangedOwnedEntity())
                {
                    if (entry.State == EntityState.Added && entry.Entity is ICreated created)
                    {
                        created.CreatedAt = utcNow;
                        created.CreatedBy = _user.Id;
                    }

                    if (entry.Entity is IModified modified)
                    {
                        modified.ModifiedAt = utcNow;
                        modified.ModifiedBy = _user.Id;
                    }
                }

                if (entry.State == EntityState.Deleted && entry.Entity is IDeleted deleted)
                {
                    deleted.IsDeleted = true;
                    deleted.DeletedAt = utcNow;
                    deleted.DeletedBy = _user.Id;

                    entry.State = EntityState.Modified;
                }

                auditEntries.Add(GetAuditEntry(entry));
            }

            foreach (var auditEntry in auditEntries)
            {
                context.Add(auditEntry.ToActivityLog());
            }
        }

        private AuditEntry GetAuditEntry(EntityEntry entry)
        {
            var auditEntry = new AuditEntry(entry);

            auditEntry.UserId = _user.Id!;
            auditEntry.EntityType = entry.Entity.GetType().Name;
            auditEntry.IpAddress = _user.IpAddress;
            auditEntry.UserAgent = _user.UserAgent;
            auditEntry.CreatedAt = _timeProvider.GetUtcNow();

            foreach (var property in entry.Properties)
            {
                var propertyName = property.Metadata.Name;
                if (property.Metadata.IsPrimaryKey())
                {
                    auditEntry.KeyValues[propertyName] = property.CurrentValue;
                    continue;
                }

                switch (entry.State)
                {
                    case EntityState.Added:
                        {
                            auditEntry.Type = AuditType.Create;
                            auditEntry.NewValues[propertyName] = property.CurrentValue;
                            break;
                        }
                    case EntityState.Deleted:
                        {
                            auditEntry.Type = AuditType.Delete;
                            auditEntry.OldValues[propertyName] = property.OriginalValue;
                            break;
                        }
                    case EntityState.Modified:
                        {
                            if (property.IsModified)
                            {
                                auditEntry.Type = AuditType.Update;
                                auditEntry.ChangedColumns.Add(propertyName);
                                auditEntry.OldValues[propertyName] = property.OriginalValue;
                                auditEntry.NewValues[propertyName] = property.CurrentValue;
                            }
                            break;
                        }
                }
            }

            return auditEntry;
        }
    }
}

public static class EntityEntryExtensions
{
    public static bool HasChangedOwnedEntity(this EntityEntry entry)
        => entry.References.Any(r =>
        r.TargetEntry != null &&
        r.TargetEntry.Metadata.IsOwned() &&
        (r.TargetEntry.State == EntityState.Added || r.TargetEntry.State == EntityState.Modified));
}