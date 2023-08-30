using BusMEAPI.Database;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Http.HttpResults;
using Microsoft.AspNetCore.Mvc;
using Microsoft.IdentityModel.Tokens;

namespace BusMEAPI
{
    [ApiController]
    [Route("auth")]
    class AuthController : ControllerBase
    {

        private readonly BusMEContext _context;
        private readonly BaseAuthService _auth; 
        public AuthController(BusMEContext dbContext, BaseAuthService service)
        {
            _context = dbContext;
            _auth = service;
        }


        [AllowAnonymous]
        [HttpGet]
        [Route("login")]
        public async Task<ActionResult> Login(Login login)
        {
            if (login == null)
                return new StatusCodeResult(403);

            SecurityToken? token = await _auth.LoginUser(login);

            if (token == null)
                return new ForbidResult();

            return new JsonResult(token);
        }
    }
}