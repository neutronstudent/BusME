using Microsoft.EntityFrameworkCore;

namespace BusMEAPI.Database
{
    public class BusMEContext : DbContext
    {
        public DbSet<User> users;
    }
}