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
        public DbSet<BusRoute> BusRoutes {get; set;}

        public DbSet<BusStop>  BusStops {get; set;}

        public DbSet<BusTrip> BusTrips {get; set;}
    }
}