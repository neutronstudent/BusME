using Microsoft.AspNetCore.Authentication;

namespace BusMEAPI
{
    public class DBUserController : UserController
    {
        private DbInterface db;

        public DBUserController(DbInterface db)
        {
            this.db = db;
        }
        


        public override int CreateUser(User user)
        {
            throw new NotImplementedException();
        }

        public override int DeleteUser(int id)
        {
            throw new NotImplementedException();
        }

        public override User GetUser(int id)
        {
            throw new NotImplementedException();
        }

        public override User GetUser(string username)
        {
            throw new NotImplementedException();
        }


        public override int UpdateUser(User user)
        {
            throw new NotImplementedException();
        }
    }
}