using EMS.Core.Enums;

namespace EMS.Core.Specifications.Common
{
    public abstract class PaginationSpecParams
    {
        protected virtual int MaxPageSize => 100;
        private int _pageSize = 5;
        public int PageSize { get => _pageSize; set => _pageSize = value > MaxPageSize ? MaxPageSize : value; }
        public int PageNumber { get; set; } = 1;
        public virtual SortDirection? Sort { get; set; } = SortDirection.DESC;
    }
}
