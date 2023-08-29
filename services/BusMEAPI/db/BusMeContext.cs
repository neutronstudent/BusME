using Microsoft.EntityFrameworkCore;

namespace BusMEAPI.Database
{
    public class BusMEContext : DbContext
    {
        protected readonly IConfiguration Configuration;

        public BusMEContext(IConfiguration configuration)
        {
            Configuration = configuration;
        }

        protected override void OnConfiguring(DbContextOptionsBuilder optionsBuilder)
        {
            optionsBuilder.UseNpgsql(Configuration.GetConnectionString("WebApiDatabase"));
        }

        public DbSet<User> Users {get; set; }
    }
}