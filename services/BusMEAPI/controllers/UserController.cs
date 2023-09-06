using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Authentication;
using Microsoft.AspNetCore.Authorization;

namespace BusMEAPI.Controllers
{
    [ApiController]
    [Route("api/users")]
    public class UserController : ControllerBase 
    {
        private BaseUserService _userMang;

        public UserController(BaseUserService userController)
        {
            _userMang = userController;
        }

        public class UserCreateRequest
        {
            public User user {get; set;}
            public string password {get; set;}
        }
        
        [HttpPost]
        [AllowAnonymous]
        public async Task<ActionResult> AddUser(UserCreateRequest user)
        {
                //attempt to create user with the above infomation
               int status = await _userMang.CreateUser(user.user, user.password);

               if (status != 0)
                    return StatusCode(304);
                else
                    return StatusCode(201);
        }

        
        

        [HttpGet]
        [Authorize(policy:"UserOnly")]
        public async Task<ActionResult<User>> GetUser(string? username, int? id)
        {
            User? user = null;
            if (id != null)
            {
                user = await _userMang.GetUser(id.Value); 
            }
            else if (username != null)
            {
                user = await _userMang.GetUser(username); 
            }
            
            
            if (user == null)
                return new NotFoundResult();
            
            return new JsonResult(user);
        }

        [HttpGet]
        [Route("search")]
        [Authorize(policy:"AdminOnly")]
        public async Task<ActionResult> SearchUser(string query)
        {
            if (!(query.Length > 0))
                return StatusCode(404);
            
            return new JsonResult(await _userMang.SearchUser(query));
        }       
    } 
}