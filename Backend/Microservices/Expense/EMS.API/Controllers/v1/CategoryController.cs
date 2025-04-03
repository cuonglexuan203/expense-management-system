using EMS.API.Common.Attributes;
using EMS.Application.Features.Categories.Commands.CreateCategory;
using EMS.Application.Features.Categories.Commands.DeleteCategory;
using EMS.Application.Features.Categories.Commands.UpdateCategory;
using EMS.Application.Features.Categories.Dtos;
using EMS.Application.Features.Categories.Queries.GetCategories;
using EMS.Application.Features.Categories.Queries.GetCategoryById;
using EMS.Application.Features.Categories.Queries.GetDefaultCategories;
using EMS.Core.Specifications;
using MediatR;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace EMS.API.Controllers.v1
{
    [Authorize]
    [ApiRoute("categories")]
    public class CategoryController : ApiControllerBase
    {
        private readonly ISender _sender;

        public CategoryController(ISender sender)
        {
            _sender = sender;
        }

        [HttpGet]
        public async Task<IActionResult> GetCategories([FromQuery] CategorySpecParams specParams)
        {
            var result = await _sender.Send(new GetCategoriesQuery(specParams));

            return Ok(result);
        }

        [HttpGet("{id}")]
        public async Task<ActionResult<CategoryDto>> GetCategory(int id)
        {
            return await _sender.Send(new GetCategoryByIdQuery(id));
        }

        [HttpPost]
        public async Task<ActionResult<CategoryDto>> Create(CreateCategoryCommand command)
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

        [HttpGet("defaults")]
        public async Task<IActionResult> GetDefaultCategories()
        {
            var result = await _sender.Send(new GetDefaultCategoriesQuery());

            return Ok(result);
        }
    }
}