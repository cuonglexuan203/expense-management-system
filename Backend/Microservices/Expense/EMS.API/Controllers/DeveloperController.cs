using Microsoft.AspNetCore.Mvc;

namespace EMS.API.Controllers
{
    public class DeveloperController : ApiControllerBase
    {
        public DeveloperController()
        {
            
        }

        [HttpGet("[action]")]
        public async Task<IActionResult> GetPiCoin()
        {
            return Ok(new { Message = "You get 10k PI coins", Coin = 10000 });
        }
    }
}
