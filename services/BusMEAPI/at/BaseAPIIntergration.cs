namespace BusMEAPI
{
    public abstract class BaseAPIIntergration
    {

        public abstract Task<int> UpdateTrips(int Id);

        public abstract Task<int> UpdateRoutes();
        
    }
}