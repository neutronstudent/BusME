using BusMEAPI.Database;
using Microsoft.AspNetCore.Authentication;
using Microsoft.EntityFrameworkCore;


namespace BusMEAPI
{
    public class DBUserController : UserController
    {
        private BusMEContext _context;

        public DBUserController(BusMEContext context)
        {
            this._context = context;
        }
        


        public async override Task<int> CreateUser(User user)
        {
            await _context.Users.AddAsync(user);
            await _context.SaveChangesAsync();

            return 0;
        }

        public async override Task<int> DeleteUser(int id)
        {
            var query = from u in _context.Users 
                where u.Id == id
                select u;
            
            User? user = await query.FirstOrDefaultAsync();

            if (user == null)
            {
                return 1;
            }

            _context.Users.Remove(user);

            
            await _context.SaveChangesAsync();
            return 0;
        }

        public async override Task<User?> GetUser(int id)
        {
            var query = from u in _context.Users 
                where u.Id == id
                select u;
            
            return await query.FirstOrDefaultAsync();
        }

        public async override Task<User?> GetUser(string username)
        {
            var query = from u in _context.Users 
                where u.Name == username
                select u;
            
            return await query.FirstOrDefaultAsync();

        }


        public async override Task<int> UpdateUser(User user)
        {
            _context.Users.Update(user);

            return await _context.SaveChangesAsync();

        }
    }
}