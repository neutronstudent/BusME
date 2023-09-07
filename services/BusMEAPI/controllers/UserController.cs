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
            public User UserInfo {get; set;}
            public string Password {get; set;}
        }
        
        [HttpPost]
        [Authorize(policy:"AdminOnly")]
        public async Task<ActionResult> AddUser(UserCreateRequest user)
        {
                //attempt to create user with the above infomation
               int status = await _userMang.CreateUser(user.UserInfo, user.Password);

               if (status != 0)
                    return StatusCode(304);
                else
                    return StatusCode(201);
        }

        [HttpPost]
        [AllowAnonymous]
        [Route("register")]
        public async Task<ActionResult> RegisterUser(UserCreateRequest user)
        {
                //overidde user type field to ensue no hacking 
                user.UserInfo.Type = 0;

                //attempt to create user with the above infomation
               int status = await _userMang.CreateUser(user.UserInfo, user.Password);

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
        public async Task<ActionResult> SearchUser(string query, int? page)
        {
            if (!(query.Length > 0))
                return StatusCode(404);
            
            return new JsonResult(await _userMang.SearchUser(query, page.HasValue ? page.Value : 0));
        }    
                [HttpGet]
        [Authorize(policy:"UserOnly")]


        [HttpDelete]
        [Authorize(policy:"AdminOnly")]
        public async Task<ActionResult<User>> DeleteUser(int? id)
        {
            User? user = null;

            if (id != null)
            {
                user = await _userMang.GetUser(id.Value); 
            }
            
            
            if (user != null)
            {
                await _userMang.DeleteUser(id.Value);
                return new OkResult();
            }
            
            return new NotFoundResult();
        }  


    } 
}