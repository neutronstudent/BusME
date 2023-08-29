using Microsoft.AspNetCore.Mvc;

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

        public async Task<ActionResult> AddUser(User user)
        {
                //attempt to create user with the above infomation
               int status = await _userMang.CreateUser(user);

               if (status != 0)
                    return StatusCode(304);
                else
                    return StatusCode(201);
        }

        [HttpGet]
        [Route("{id}")]
        public async Task<ActionResult<User>> GetUser(int id)
        {
            User user = await _userMang.GetUser(id);
            
            if (user == null)
                return new NotFoundResult();
            
            return new JsonResult(user);
        }

        [HttpGet]
        [Route("{username}")]
        public async Task<ActionResult<User>> GetUser(string username)
        {
            User user = await _userMang.GetUser(username);
            
            if (user == null)
                return new NotFoundResult();
            
            return new JsonResult(user);
        }



    } 
}