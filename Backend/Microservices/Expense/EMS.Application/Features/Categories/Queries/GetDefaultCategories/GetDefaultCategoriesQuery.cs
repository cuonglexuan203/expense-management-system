using EMS.Application.Features.Categories.Dtos;
using EMS.Application.Features.Categories.Services;
using MediatR;
using Microsoft.Extensions.Logging;

namespace EMS.Application.Features.Categories.Queries.GetDefaultCategories
{
    public record GetDefaultCategoriesQuery : IRequest<List<CategoryDto>>;

    public class GetDefaultCategoriesQueryHandler : IRequestHandler<GetDefaultCategoriesQuery, List<CategoryDto>>
    {
        private readonly ILogger<GetDefaultCategoriesQueryHandler> _logger;
        private readonly ICategoryService _categoryService;

        public GetDefaultCategoriesQueryHandler(
            ILogger<GetDefaultCategoriesQueryHandler> logger,
            ICategoryService categoryService)
        {
            _logger = logger;
            _categoryService = categoryService;
        }

        public async Task<List<CategoryDto>> Handle(GetDefaultCategoriesQuery request, CancellationToken cancellationToken)
        {
            var categoryDtoList = await _categoryService.GetDefaultCategoriesAsync();

            return categoryDtoList;
        }
    }
}
