using BusMEAPI.Database;
using Microsoft.EntityFrameworkCore;
using System.Net.Http.Headers;
namespace BusMEAPI
{
    public class AtAPIIntergration : BaseAPIIntergration
    {
        private readonly string _apiKey;
        private readonly BusMEContext _dbContext;
        private readonly ILogger<AtAPIIntergration> _logger;
        public AtAPIIntergration(BusMEContext dbContext, IConfiguration configuration, ILogger<AtAPIIntergration> logger)
        {
            _apiKey = configuration["api:key"]!;
            _dbContext = dbContext;
            _logger = logger;
        }

        //GET https://api.at.govt.nz/gtfs/v3/routes/{id}/trips
        //GET https://api.at.govt.nz/gtfs/v3/trips/{id}/stops

        //assume that route is a ef tracked object
        public override async Task<int> UpdateTrips()
        {
            //get 
            string apiRoute = "https://api.at.govt.nz/realtime/legacy/tripupdates";

            //get trips hard data (no positions or anything) and bind to routes
            RealtimeResponse<TripEntity>? trips = await MakeRequest<RealtimeResponse<TripEntity>>(apiRoute);
            if (trips == null || trips.response == null)
            {
                return 1;
            }

            //for each trip write to database no extra if exists
            foreach (TripEntity update in trips.response.entity)
            {
                                //NULL CHECK 2!!!!
                if (update == null  || update.trip_update == null ||update.trip_update.trip == null)
                {
                    continue;
                }
                RealtimeTrip trip = update.trip_update.trip;

                var query  = from u in _dbContext.BusRoutes.Include("Trips") where u.RouteId == trip.route_id select u;

                BusRoute? route = await query.FirstOrDefaultAsync();
                
                if (route == null)
                {
                    continue;
                }


                //build trip from data 
                var existingTripQuery = from u in route.Trips where u.ApiTripID == trip.trip_id select u;

                BusTrip? newTrip = existingTripQuery.FirstOrDefault();

                if (newTrip == null)
                {
                    newTrip = new BusTrip();
                    await _dbContext.BusTrips.AddAsync(newTrip);
                    route.Trips.Add(newTrip);
                    
                    
                }

                //populate trip with update fields
                newTrip.ApiTripID = trip.trip_id;
                newTrip.BusRoute = route;
                newTrip.BusRouteId = route.Id;
                newTrip.Direction = trip.direction_id;
                newTrip.StartTime = DateTime.ParseExact(trip.start_date + ":" + trip.start_time, "yyyyMMdd:HH:mm:ss", null).ToUniversalTime();
            }
            await _dbContext.SaveChangesAsync();

            

            return 0;
        }
        
        //update with realtime api data (depature time, position etc etc )
        public override async Task<int> UpdateLive()
        {
             //get 
            string apiRoute = "https://api.at.govt.nz/realtime/legacy/vehiclelocations";

            //get trips hard data (no positions or anything) and bind to routes
            RealtimeResponse<VehicleUpdate>? trips = await MakeRequest<RealtimeResponse<VehicleUpdate>>(apiRoute);

            if (trips == null || trips.response == null)
            {
                return 1;
            }

            //for each trip write to database no extra if exists
            foreach (VehicleUpdate update in trips.response.entity)
            {
                //check update has all required fields
                if (update == null || update.vehicle == null || update.vehicle.trip == null)
                {
                    continue;
                }

                var query  = from u in _dbContext.BusRoutes.Include("Trips") where u.RouteId == update.vehicle.trip.route_id select u;

                BusRoute? route = await query.FirstOrDefaultAsync();

                //NULLL CHEEECK!!!!
                if (route == null)
                {
                    continue;
                }
                
                //build trip from data 
                var existingTripQuery = from u in route.Trips where u.ApiTripID == update.vehicle.trip.trip_id select u;
                BusTrip? trip = existingTripQuery.FirstOrDefault();

                if (trip == null)
                {
                    continue;
                }

                //populate trip with update fields
                trip.Lat = update.vehicle.position.latitude;
                trip.Long = update.vehicle.position.longitude;
            }

            await _dbContext.SaveChangesAsync();

            return 0;
        }

        //get the stops associated with a trip...
        public async Task<int> GetStops(int id)
        {
            return 0;
        }

        public async Task<int> UpdateStops(int id)
        {
            return 0;
        }

        //should be bound to a cron job 
        public override async Task<int> UpdateRoutes()
        {
            //get routes from at api 
            string api_route = "https://api.at.govt.nz/gtfs/v3/routes";

            //wipe old routes trips and stops 


            MultipleEntityResponse<Route>? routes = await MakeRequest<MultipleEntityResponse<Route>>(api_route);

            if (routes == null || routes.data == null)
            {
                return 1;
            }

            //now convert into database routes if possible
            foreach (ResponseData<Route> at_route in routes.data)
            {
                //for each route conver to database
                if (at_route.attributes == null)
                {
                    continue;
                }

                //now just return other stuff 
                BusRoute busRoute = new BusRoute();
                busRoute.RouteId = at_route.attributes.route_id;
                busRoute.RouteLongName = at_route.attributes.route_long_name;
                busRoute.RouteShortName = at_route.attributes.route_short_name;
                
                //TODO write routes to database if not already exist, else update other values 
                var query = from r in _dbContext.BusRoutes where String.Compare(r.RouteId, busRoute.RouteId) == 0 select r;

                BusRoute? existingRoute = await query.FirstOrDefaultAsync();
                
                if (existingRoute != null)
                {
                    existingRoute.RouteLongName = busRoute.RouteLongName;
                    existingRoute.RouteShortName = busRoute.RouteShortName;
                }
                else
                {
                    _dbContext.BusRoutes.Add(busRoute);
                }
            }

            await _dbContext.SaveChangesAsync();

            //return 0

            return 0;
        }


        private async Task<T?> MakeRequest<T>(string path)
        {
            try{
                var client = new HttpClient();
                // Request headers
                client.DefaultRequestHeaders.CacheControl = CacheControlHeaderValue.Parse("no-cache");
                client.DefaultRequestHeaders.Add("Ocp-Apim-Subscription-Key", _apiKey);//Change this to correct api key
                var response = await client.GetAsync(path);
                if (response != null){
                    return await response.Content.ReadFromJsonAsync<T>();
                }
                
            }
            catch (Exception ex)
            {
                _logger.LogError(ex.ToString());
                return default(T);
            }

            return default(T);
        }


        //api utility classes

        private class Route
        {
            public string route_id {get; set;}
            public string? route_short_name {get; set;}
            public string? route_long_name {get; set;}
            public string? route_desc {get; set;}
            public int? route_type {get; set;}
        }


        private class Stop 
        {
            public float stop_lat {get; set;}

            public float stop_lon {get; set;}

            public string? stop_code {get; set;}

            public string? stop_id {get; set;}

            public string? stop_name {get; set;}

            public int? wheelchair_boarding {get; set;}
        }

        //ensure that 

        private class ResponseData<T>
        {
            public string? type  {get; set;}
            public string? id    {get; set;}
            public T? attributes {get; set;}

        }

        private class MultipleEntityResponse<T>
        {
            public ResponseData<T>[]? data {get; set;}
        }

        private class RealtimeResponse<T>
        {
            public string status {get; set;}
            public RealtimeResponseData<T> response {get; set;}
        }
        private class RealtimeTrip
        {
            public string trip_id {get; set;}
            public string route_id {get; set;}
            public int direction_id {get; set;}
            public string start_time {get; set;}
            public string start_date {get; set;}
            public int schedule_relationship {get; set;}
        }

        private class Vehicle
        {
            public string id {get; set;}
            public string label {get; set;}
             public string licence_plate {get; set;}
        }


        private class TripUpdate
        {

            public Vehicle vehicle {get; set;}
            public RealtimeTrip trip {get; set;}
        }
        private class TripEntity
        {
            public string id {get; set;}
            public bool is_deleted {get; set;}
            public TripUpdate trip_update {get; set;}
        }
        private class Position
        {
            public float latitude {get; set;}
            public float longitude {get; set;}
            public float bearing {get; set;}
        }
        private class VehicleUpdate
        {
            public string id {get; set;}
            public bool is_deleted {get; set;}

            public VehiclePosition vehicle {get; set;}
        }
        
        private class VehiclePosition
        {
            public RealtimeTrip? trip {get; set;}
            public Position? position {get; set;}
            public Vehicle? vehicle {get; set;}
        }


        private class RealtimeHeader
        {
            public string? gtfs_realtime_version {get; set;}
            public int? incrementality {get; set;}
        }

        private class RealtimeResponseData<T>
        {
            public RealtimeHeader? header {get; set;}
            public List<T> entity {get; set;}
        }
        

        

    }

}