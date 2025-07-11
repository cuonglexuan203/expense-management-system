﻿using EMS.Application.Common.Interfaces.Services;
using EMS.Infrastructure.Persistence.DbContext;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Logging;
using System.Data;

namespace EMS.Infrastructure.Services
{
    public class DatabaseTransactionManager : IDatabaseTransactionManager
    {
        private readonly ILogger<DatabaseTransactionManager> _logger;
        private readonly ApplicationDbContext _context;

        public DatabaseTransactionManager(
            ILogger<DatabaseTransactionManager> logger,
            ApplicationDbContext context)
        {
            _logger = logger;
            _context = context;
        }

        public async Task ExecuteInTransactionAsync(
            Func<Task> operation,
            bool clearChangeTrackerOnRollback = false,
            IsolationLevel isolationLevel = IsolationLevel.ReadCommitted)
        {
            var strategy = _context.Database.CreateExecutionStrategy();
            await strategy.ExecuteAsync(async () =>
            {
                using var transaction = await _context.Database.BeginTransactionAsync(isolationLevel);
                try
                {
                    await operation();
                    await transaction.CommitAsync();
                }
                catch (Exception ex)
                {
                    _logger.LogError(ex, "Database transaction failed and was rolled back");
                    await transaction.RollbackAsync();

                    if (clearChangeTrackerOnRollback)
                    {
                        _context.ChangeTracker.Clear();
                    }

                    throw;
                }
            });
        }

        public async Task<TResult> ExecuteInTransactionAsync<TResult>(
            Func<Task<TResult>> operation,
            bool clearChangeTrackerOnRollback = false,
            IsolationLevel isolationLevel = IsolationLevel.ReadCommitted)
        {
            var strategy = _context.Database.CreateExecutionStrategy();
            return await strategy.ExecuteAsync(async () =>
            {
                using var transaction = await _context.Database.BeginTransactionAsync(isolationLevel);
                try
                {
                    var result = await operation();
                    await transaction.CommitAsync();

                    return result;
                }
                catch (Exception ex)
                {
                    _logger.LogError(ex, "Database transaction failed and was rolled back");
                    await transaction.RollbackAsync();

                    if (clearChangeTrackerOnRollback)
                    {
                        _context.ChangeTracker.Clear();
                    }

                    throw;
                }
            });
        }
    }
}
