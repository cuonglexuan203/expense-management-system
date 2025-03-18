using EMS.Core.Entities;
using EMS.Core.Enums;

namespace EMS.Application.Features.Categories.Services
{
    public interface ICategoryService
    {
        Task<Category> GetDefaultCategoryAsync(TransactionType type);
    }
}
