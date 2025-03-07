using EMS.Application.Features.Category.Commands.CreateCategory;
using EMS.Application.Features.Category.Commands.DeleteCategory;
using EMS.Application.Features.Category.Commands.UpdateCategory;
using EMS.Application.Features.Category.Queries.GetCategories;
using EMS.Application.Features.Category.Queries.GetCategory;
using MediatR;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace EMS.API.Controllers
{
    [Authorize]
    public class CategoryController : ApiControllerBase
    {
        private readonly ISender _sender;

        public CategoryController(ISender sender)
        {
            _sender = sender;
        }

        [HttpGet]
        public async Task<ActionResult<List<CategoryDto>>> GetCategories()
        {
            return await _sender.Send(new GetCategoriesQuery());
        }

        [HttpGet("{id}")]
        public async Task<ActionResult<CategoryDto>> GetCategory(int id)
        {
            return await _sender.Send(new GetCategoryQuery(id));
        }

        [HttpPost]
        public async Task<ActionResult<int>> Create(CreateCategoryCommand command)
        {
            return await _sender.Send(command);
        }

        [HttpPut("{id}")]
        public async Task<ActionResult<int>> Update(int id, UpdateCategoryCommand command)
        {
            if (id != command.Id)
            {
                return BadRequest();
            }

            return await _sender.Send(command);
        }

        [HttpDelete("{id}")]
        public async Task<ActionResult> Delete(int id)
        {
            await _sender.Send(new DeleteCategoryCommand(id));
            return NoContent();
        }
    }
}