using Microsoft.AspNetCore.Authentication;

namespace BusMEAPI
{
    public class DBUserController : UserController
    {
        private DbInterface _db;

        public DBUserController(DbInterface db)
        {
            this._db = db;
        }
        


        public async override Task<int> CreateUser(User user)
        {
            return await _db.InsertUser(user);
            throw new NotImplementedException();
        }

        public async override Task<int> DeleteUser(int id)
        {
            return await _db.DeleteUser(id);
        }

        public async override Task<User> GetUser(int id)
        {
            return await _db.GetUser(id);
            throw new NotImplementedException();
        }

        public async override Task<User> GetUser(string username)
        {
            return await _db.GetUser(username);
        }


        public async override Task<int> UpdateUser(User user)
        {
            return await _db.UpdateUser(user);
        }
    }
}