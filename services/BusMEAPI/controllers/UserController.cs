using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Authentication;
using Microsoft.AspNetCore.Authorization;
using System.Security.Claims;

namespace BusMEAPI.Controllers
{
    [ApiController]
    [Route("api/users")]
    public class UserController : ControllerBase 
    {
        private BaseUserService _userMang;
        private IHttpContextAccessor _httpContextAccessor;
        public UserController(BaseUserService userController, IHttpContextAccessor httpContextAccessor)
        {
            _userMang = userController;
            _httpContextAccessor = httpContextAccessor;
        }

        public class UserCreateRequest
        {
            public string Username {get; set;}
            public UserDetails Details {get; set;}

            public string Password {get; set;}
        }
        
        [HttpPost]
        [Authorize(policy:"AdminOnly")]
        public async Task<ActionResult> AddUser(UserCreateRequest user, User.UserType type)
        {
                User newUser = new User();
                newUser.Details = user.Details;
                newUser.Username = user.Username;
                newUser.Type = type;

                //attempt to create user with the above infomation
               int status = await _userMang.CreateUser(newUser, user.Password);

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
            User newUser = new User();
            //overidde user type field to ensue no hacking 
            newUser.Type = BusMEAPI.User.UserType.User;
            newUser.Details = user.Details;
            newUser.Username = user.Username;
                
                //attempt to create user with the above infomation
               int status = await _userMang.CreateUser(newUser, user.Password);

               if (status != 0)
                    return StatusCode(304);
                else
                    return StatusCode(201);
        }
        

        //get user 
        [HttpGet]
        [Authorize(policy:"UserOnly")]
        [Route("{id}")]
        public async Task<ActionResult<User>> GetUser(int? id)
        {
            //run check 


            User? user = null;
            if (id != null)
            {
                HttpContext context = _httpContextAccessor.HttpContext;
                if  (!context.User.FindFirstValue(ClaimTypes.Actor).Equals(id.ToString()) && !context.User.FindFirstValue(ClaimTypes.Role).Equals("admin"))
                {
                    return new ForbidResult();
                }
                
                user = await _userMang.GetUser(id.Value); 
            }
            
            
            if (user == null)
                return new NotFoundResult();
            
            return new JsonResult(user);
        }


        //search, only allow admin
        [HttpGet]
        [Authorize(policy:"AdminOnly")]
        public async Task<ActionResult> SearchUser(string query, int? page)
        {
            if (!(query.Length > 0))
                return StatusCode(404);
            
            return new JsonResult(await _userMang.SearchUser(query, page.HasValue ? page.Value : 0));
        }    


        //only allow admin to delete users
        [HttpDelete]
        [Authorize(policy:"AdminOnly")]
        [Route("{id}")]
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

        //has to be user minimum, if you are admin you can change other users, else can only change yourself
        [HttpPut]
        [Authorize(policy:"AdminOnly")]
        [Route("{id}")]
        public async Task<ActionResult> UpdateUser(int id, User user)
        {
            //overide id
            user.Id = id;

            if (await _userMang.UpdateUser(user) != 0)
            {
                return new NotFoundResult();
            }
            else
            {
                return new OkResult();
            }

            
        }

                //has to be user minimum, if you are admin you can change other users, else can only change yourself
        [HttpPut]
        [Authorize(policy:"UserOnly")]
        [Route("{id}/details")]
        public async Task<ActionResult> UpdateUserDetials(int id, UserDetails details)
        {
            //overide id
        

            //do claims checking
            HttpContext context = _httpContextAccessor.HttpContext!;
            if  (!context.User.FindFirstValue(ClaimTypes.Actor).Equals(id.ToString()) && !context.User.FindFirstValue(ClaimTypes.Role).Equals("admin"))
            {
                return new ForbidResult();
            }

            if (await _userMang.UpdateUserDetails(id, details) != 0)
            {
                return new NotFoundResult();
            }
            else
            {
                return new OkResult();
            }
        }

        [HttpPut]
        [Authorize(policy:"UserOnly")]
        [Route("{id}/settings")]
        public async Task<ActionResult> UpdateUserSettings(int id, UserSettings settings)
        {
            //overide id
        

            //do claims checking
            HttpContext context = _httpContextAccessor.HttpContext!;
            if  (!context.User.FindFirstValue(ClaimTypes.Actor).Equals(id.ToString()) && !context.User.FindFirstValue(ClaimTypes.Role).Equals("admin"))
            {
                return new ForbidResult();
            }

            if (await _userMang.UpdateUserSettings(id, settings) != 0)
            {
                return new NotFoundResult();
            }
            else
            {
                return new OkResult();
            }
        }


    } 
}