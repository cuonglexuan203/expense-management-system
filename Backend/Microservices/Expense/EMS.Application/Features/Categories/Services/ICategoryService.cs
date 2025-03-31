using EMS.Application.Features.Categories.Dtos;
using EMS.Core.Entities;
using EMS.Core.Enums;

namespace EMS.Application.Features.Categories.Services
{
    public interface ICategoryService
    {
        Task<Category> GetUnknownCategoryAsync(TransactionType type);
        Task<List<CategoryDto>> GetDefaultCategoriesAsync();
    }
}
