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

        public ActionResult AddUser(User user)
        {
                //attempt to create user with the above infomation
               int status = _userMang.CreateUser(user);

               if (status != 0)
                    return StatusCode(304);
                else
                    return StatusCode(201);
        }

        [HttpGet]
        [Route("{id}")]
        public ActionResult<User> GetUser(int id)
        {
            User user = _userMang.GetUser(id);
            
            if (user == null)
                return new NotFoundResult();
            
            return new JsonResult(user);
        }

        [HttpGet]
        [Route("{username}")]
        public ActionResult<User> GetUser(string username)
        {
            User user = _userMang.GetUser(username);
            
            if (user == null)
                return new NotFoundResult();
            
            return new JsonResult(user);
        }

        

    } 
}