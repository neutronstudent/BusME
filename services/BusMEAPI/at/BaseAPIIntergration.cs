namespace BusMEAPI
{
    public abstract class BaseAPIIntergration
    {

        public abstract Task<int> UpdateTrips();

        public abstract Task<int> UpdateRoutes();
        public abstract Task<int> UpdateLive();

        public abstract Task<List<BusStop>> GetStops(int TripID);

        public abstract Task<List<BusRoute>> GetRoutes();

        public abstract Task<BusRoute?> GetRoute(int route);
    }
}