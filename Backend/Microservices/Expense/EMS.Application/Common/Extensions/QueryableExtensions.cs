using AutoMapper;
using AutoMapper.QueryableExtensions;
using EMS.Application.Common.Models;
using EMS.Application.Common.Utils;
using EMS.Core.Entities;
using EMS.Core.Enums;
using Microsoft.EntityFrameworkCore;

namespace EMS.Application.Common.Extensions
{
    public static class QueryableExtensions
    {
        public static Task<PaginatedList<T>> ToPaginatedList<T>(this IQueryable<T> queryable, int pageNumber, int pageSize)
            where T : class
         => PaginatedList<T>.CreateAsync(queryable.AsNoTracking(), pageNumber, pageSize);

        public static Task<List<T>> ProjectToListAsync<T>(this IQueryable queryable, IConfigurationProvider configurationProvider)
            where T : class
        => queryable.ProjectTo<T>(configurationProvider).AsNoTracking().ToListAsync();

        public static IQueryable<Transaction> FilterTransactionsByPeriod(this IQueryable<Transaction> query, TimePeriod period)
        {
            var now = DateTimeOffset.UtcNow;
            return period switch
            {
                TimePeriod.CurrentWeek => query.Where(e => e.CreatedAt > DateTimeUtil.GetStartDateOfWeek(now)),
                TimePeriod.CurrentMonth => query.Where(e => e.CreatedAt > new DateTimeOffset(now.Year, now.Month, 1, 0, 0, 0, TimeSpan.Zero)),
                TimePeriod.CurrentYear => query.Where(e => e.CreatedAt > new DateTimeOffset(now.Year, 1, 1, 0, 0, 0, TimeSpan.Zero)),
                TimePeriod.AllTime => query,
                _ => throw new ArgumentOutOfRangeException(nameof(period), period, null),
            };
        }
    }
}
