using EMS.Application.Features.Categories.Dtos;
using EMS.Core.Entities;
using EMS.Core.Enums;

namespace EMS.Application.Features.Categories.Services
{
    public interface ICategoryService
    {
        Task<Category> GetUnknownCategoryAsync(TransactionType type); // System category
        Task<CategoryDto> GetUnknownCategoryAsync(string userId, TransactionType type); // user-custom category
        Task<List<CategoryDto>> GetDefaultCategoriesAsync();
        Task<List<CategoryDto>> GetCategoriesAsync(string userId);
    }
}
