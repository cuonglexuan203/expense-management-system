using EMS.Application.Common.Interfaces.DbContext;
using EMS.Application.Common.Interfaces.Services;
using EMS.Application.Common.Utils;
using EMS.Application.Features.Categories.Services;
using EMS.Core.Entities;
using EMS.Core.Enums;
using EMS.Core.Exceptions;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Logging;

namespace EMS.Infrastructure.Services
{
    public class CategoryService : ICategoryService
    {
        private readonly ILogger<CategoryService> _logger;
        private readonly IApplicationDbContext _context;
        private readonly IDistributedCacheService _cacheService;

        //
        private const string _defaultCategoryName = "Unknown";

        public CategoryService(
            ILogger<CategoryService> logger,
            IApplicationDbContext context,
            IDistributedCacheService cacheService)
        {
            _logger = logger;
            _context = context;
            _cacheService = cacheService;
        }

        public async Task<Category> GetDefaultCategoryAsync(TransactionType type)
        {
            return await _cacheService.GetOrSetAsync(
                CacheKeyGenerator.Generate(CacheKeyGenerator.GeneralKeys.DefaultCategory),
                async () => await _context.Categories
                .AsNoTracking()
                .Where(e => !e.IsDeleted &&
                            e.Type == CategoryType.Default &&
                            e.FinancialFlowType == type &&
                            e.Name == _defaultCategoryName)
                .FirstOrDefaultAsync() ?? throw new ServerException("Default category not found."), TimeSpan.FromDays(1));
        }
    }
}
