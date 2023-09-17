namespace BusMEAPI
{
    public abstract class BaseAPIIntergration
    {

        public abstract Task<int> UpdateTrips();

        public abstract Task<int> UpdateRoutes();
        public abstract Task<int> UpdateLive();
    }
}