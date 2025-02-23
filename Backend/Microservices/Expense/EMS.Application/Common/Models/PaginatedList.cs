using Microsoft.EntityFrameworkCore;

namespace EMS.Application.Common.Models
{
    public class PaginatedList<T>
    {
        public IReadOnlyCollection<T> Items { get; } = default!;
        public int PageNumber { get; }
        public int TotalPages { get; }
        public int TotalCount { get; }

        public PaginatedList(IReadOnlyCollection<T> items, int count, int pageNumber, int pageSize)
        {
            Items = items;
            PageNumber = pageNumber;
            TotalPages = (int)Math.Ceiling(count / (pageSize * 1.0));
            TotalCount = count;
        }

        public bool HasPreviousPage => PageNumber > 1;
        public bool HasNextPage => PageNumber < TotalPages;

        public static async Task<PaginatedList<T>> CreateAsync(IQueryable<T> source, int pageNumber, int pageSize)
        {
            var count = await source.CountAsync();
            var items = await source
                .Skip((pageNumber - 1) * pageSize)
                .Take(pageSize)
                .ToListAsync();

            return new(items, count, pageNumber, pageSize);
        }
    }
}
