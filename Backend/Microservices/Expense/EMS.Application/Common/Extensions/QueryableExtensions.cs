using AutoMapper;
using AutoMapper.QueryableExtensions;
using EMS.Application.Common.Models;
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
    }
}
