using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Authentication;
using Microsoft.AspNetCore.Authorization;

namespace BusMEAPI
{
    [ApiController]
    [Route("users")]
    public class UserApiController : ControllerBase 
    {
        private UserController _userMang;


        public UserApiController(UserController userController)
        {
            _userMang = userController;
        }

        [HttpPost]
        [Authorize(policy:"UserOnly")]
        public async Task<ActionResult> AddUser(User user, string password)
        {
                //attempt to create user with the above infomation
               int status = await _userMang.CreateUser(user, password);

               if (status != 0)
                    return StatusCode(304);
                else
                    return StatusCode(201);
        }

        /*
        [HttpGet]
        [Route("{id:id}")]
        public async Task<ActionResult<User>> GetUser(int id)
        {
            User? user = await _userMang.GetUser(id);
            
            if (user == null)
                return new NotFoundResult();
            
            return new JsonResult(user);
        }
        */

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
        public async Task<ActionResult<List<User>>> SearchUser(string query)
        {
            if (!(query.Length > 0))
                return StatusCode(404);
            
            return new JsonResult(await _userMang.SearchUser(query));
        }



    } 
}