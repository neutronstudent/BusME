using BusMEAPI.Database;
using Microsoft.AspNetCore.Authentication;
using Microsoft.EntityFrameworkCore;


namespace BusMEAPI
{
    public class DbUserService : BaseUserService
    {
        private readonly BusMEContext _context;
        private readonly BaseAuthService _auth;
        private readonly int pageSize = 50;
        public DbUserService(BusMEContext context, BaseAuthService auth)
        {
            this._context = context;
            _auth = auth;
        }
        


        public async override Task<int> CreateUser(User user, string password)
        {

            //generate hashed user password
            _auth.GeneratePasswordInfo(user, password);
            
            var query = from u in _context.Users where u.Username == user.Username select u;

            if (await query.FirstOrDefaultAsync() != null)
            {
                return 1;
            }
            
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
                where u.Username == username
                select u;
            
            return await query.FirstOrDefaultAsync();

        }

        public override async Task<List<User>> SearchUser(string username_part, int page)
        {
            var query = from u in _context.Users where u.Details.Name.Contains(username_part) select u;

            //query async
            return  await query.Skip(pageSize * page).Take(pageSize).ToListAsync();
        }

        public async override Task<int> UpdateUser(User user)
        {
            _context.Users.Update(user);

            return await _context.SaveChangesAsync();

        }
        public async override Task<int> UpdateUserSettings(int id, UserSettings userSettings)
        {
            var query = from u in _context.Users where u.Id == id select u;

            User? result = await query.SingleOrDefaultAsync();

            if (result == null)
                return 1;

            result.Settings = userSettings;

            await _context.SaveChangesAsync();
            
            return 0;
        }
        public async override Task<int> UpdateUserDetails (int id, UserDetail userDetails)
        {
            var query = from u in _context.Users where u.Id == id select u;

            User? result = await query.SingleOrDefaultAsync();

            if (result == null)
                return 1;

            result.Details = userDetails;

            await _context.SaveChangesAsync();
            
            return 0;
        }
    }
}