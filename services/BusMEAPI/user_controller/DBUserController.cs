using Microsoft.AspNetCore.Authentication;

namespace BusMEAPI
{
    public class DBUserController : UserController
    {
        private DbInterface db;
        private IAuthenticationService auth;
        
        public DBUserController(DbInterface db, IAuthenticationService auth)
        {
            this.db = db;
            this.auth = auth;
        }


        public override int CreateUser(User user)
        {
            throw new NotImplementedException();
        }

        public override int UpdateUser(User user)
        {
            throw new NotImplementedException();
        }
    }
}