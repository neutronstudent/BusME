using System.IdentityModel.Tokens.Jwt;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
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
        public async Task<ActionResult<String>> Login(String username, String password )
        {
            
            Login login = new Login();

            login.Username = username;
            login.Password = password;

            SecurityTokenResult token = await _auth.LoginUser(login);

            if (token == null || token.Token == null)
                return new ForbidResult();
            
            var data = new {id = token.UserID, token = new JwtSecurityTokenHandler().WriteToken(token.Token)};
            
            return new JsonResult(data);
        }
    } 
}