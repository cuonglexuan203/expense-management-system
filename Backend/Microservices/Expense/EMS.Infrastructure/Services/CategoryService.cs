using AutoMapper;
using EMS.Application.Common.Extensions;
using EMS.Application.Common.Interfaces.DbContext;
using EMS.Application.Common.Interfaces.Services;
using EMS.Application.Common.Utils;
using EMS.Application.Features.Categories.Dtos;
using EMS.Application.Features.Categories.Services;
using EMS.Core.Constants;
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
        private readonly IMapper _mapper;

        public CategoryService(
            ILogger<CategoryService> logger,
            IApplicationDbContext context,
            IDistributedCacheService cacheService,
            IMapper mapper)
        {
            _logger = logger;
            _context = context;
            _cacheService = cacheService;
            _mapper = mapper;
        }

        public async Task<Category> GetUnknownCategoryAsync(TransactionType type)
        {
            return await _cacheService.GetOrSetAsync(
                CacheKeyGenerator.Generate(CacheKeyGenerator.GeneralKeys.UnknownCategory, type),
                async () => await _context.Categories
                .AsNoTracking()
                .Where(e => !e.IsDeleted &&
                            e.Type == CategoryType.Default &&
                            e.FinancialFlowType == type &&
                            e.Name == Categories.Unknown)
                .FirstOrDefaultAsync() ?? throw new ServerException("The system unknown category not found."),
                TimeSpan.FromDays(1));
        }

        public async Task<List<CategoryDto>> GetDefaultCategoriesAsync()
        {
            var categoryDtoList = await _cacheService.GetOrSetAsync(
                CacheKeyGenerator.Generate(CacheKeyGenerator.GeneralKeys.DefaultCategory),
                async () => await _context.Categories
                    .AsNoTracking()
                    .Where(e => e.Type == CategoryType.Default && !e.IsDeleted)
                    .ProjectToListAsync<CategoryDto>(_mapper.ConfigurationProvider),
                TimeSpan.FromDays(1));

            return categoryDtoList;
        }

        public async Task<List<CategoryDto>> GetCategoriesAsync(string userId)
        {
            var categoryDtoList = await _context.Categories
                .AsNoTracking()
                .Where(e => e.UserId == userId && !e.IsDeleted)
                .ProjectToListAsync<CategoryDto>(_mapper.ConfigurationProvider);

            return categoryDtoList;
        }
    }
}
