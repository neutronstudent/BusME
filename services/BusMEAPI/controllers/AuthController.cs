using System.IdentityModel.Tokens.Jwt;
using BusMEAPI.Database;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Http.HttpResults;
using Microsoft.AspNetCore.Mvc;
using Microsoft.IdentityModel.JsonWebTokens;
using Microsoft.IdentityModel.Tokens;
namespace BusMEAPI.Controllers
{
    [ApiController]
    [Route("api/auth")]
    public class AuthController : ControllerBase 
    {

        private BaseAuthService _auth;

        public AuthController(BaseAuthService auth)
        {
            _auth = auth;
        }
        
        [HttpGet]
        [Route("login")]
        [AllowAnonymous]
        public async Task<ActionResult<String>> Login(Login login)
        {
            if (login == null)
                return new StatusCodeResult(403);

            SecurityToken? token = await _auth.LoginUser(login);

            if (token == null)
                return new ForbidResult();
            
            return new JwtSecurityTokenHandler().WriteToken(token);
        }
    } 
}