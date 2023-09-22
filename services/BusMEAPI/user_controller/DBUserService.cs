using System.Text.RegularExpressions;
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
        private readonly ILogger<DbUserService> _logger;
        public DbUserService(BusMEContext context, BaseAuthService auth, ILogger<DbUserService> logger)
        {
            this._context = context;
            _auth = auth;
            _logger = logger;
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
            var query = from u in _context.Users.Include(u => u.Details).Include(u => u.Settings) 
                where u.Id == id
                select u;
            
            return await query.FirstOrDefaultAsync();
        }

        public async override Task<User?> GetUser(string username)
        {
            var query = from u in _context.Users.Include(u => u.Details).Include(u => u.Settings)
                where u.Username == username
                select u;
            
            return await query.FirstOrDefaultAsync();

        }

        public override async Task<List<User>> SearchUser(string username_part, int page)
        {
            _logger.LogInformation(username_part);
            var query = from u in _context.Users where Regex.IsMatch(u.Username, username_part) == true select u;

            //query async
            return  await query.ToListAsync();
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