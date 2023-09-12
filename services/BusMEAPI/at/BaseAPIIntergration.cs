namespace BusMEAPI
{
    public abstract class BaseAPIIntergration
    {

        public abstract Task<int> UpdateTrips(BusRoute route);

        public abstract Task<int> UpdateRoutes();
        
    }
}