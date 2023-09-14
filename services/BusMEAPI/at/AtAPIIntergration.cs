using BusMEAPI.Database;
using Microsoft.EntityFrameworkCore;
using System.Net.Http.Headers;
namespace BusMEAPI
{
    public class AtAPIIntergration : BaseAPIIntergration
    {
        private string _apiKey;
        private BusMEContext _dbContext;

        public AtAPIIntergration(BusMEContext dbContext, IConfiguration configuration)
        {
            _apiKey = configuration["api:key"]!;
            _dbContext = dbContext;

        }

        //GET https://api.at.govt.nz/gtfs/v3/routes/{id}/trips
        //GET https://api.at.govt.nz/gtfs/v3/trips/{id}/stops

        //assume that route is a ef tracked object
        public override async Task<int> UpdateTrips(int Id)
        {
            //get ef tracked object 
            var query = from r in _dbContext.BusRoutes where Id == r.Id select r;

            BusRoute? busRoute = await query.SingleOrDefaultAsync();

            if (busRoute == null)
            {
                return 1;
            }

            busRoute.Trips.Clear();

            //get trips based upon route ID 
            MultipleEntityResponse<Trip>? trips = await MakeRequest<MultipleEntityResponse<Trip>>(String.Format("https://api.at.govt.nz/gtfs/v3/routes/{0}/trips", busRoute.RouteId));

            if (trips == null || trips.data == null)
            {
                return 1;
            }

            //convert trips to busme data style
            foreach (ResponseData<Trip> atTrip in trips.data)
            {
                if (atTrip.attributes == null)
                {
                    continue;
                }

                var busQuery = from t in busRoute.Trips where t.ApiTripID == atTrip.attributes.trip_id select t;
                //select bustrip if not already in collection 
                BusTrip? busTrip = busQuery.FirstOrDefault();
                

                if (busTrip == null) {
                    busTrip = new BusTrip();
                    _dbContext.BusTrips.Add(busTrip);
                } 



                busTrip.ApiTripID = atTrip.attributes.trip_id;
                busTrip.BusRoute = busRoute;
                busTrip.BusRouteId = busRoute.Id;
                busTrip.Direction = atTrip.attributes.direction_id;
                busTrip.Service = atTrip.attributes.trip_short_name;

                //query stops for trip 

                string stopQuery = String.Format("https://api.at.govt.nz/gtfs/v3/trips/{0}/stops", busTrip.ApiTripID);
                MultipleEntityResponse<Stop>? stops = await MakeRequest<MultipleEntityResponse<Stop>>(stopQuery);

                if (stops == null || stops.data == null)
                {
                    continue;
                }

                //for each stop check if already in list if so update else skip 
                foreach(ResponseData<Stop> atStop in stops.data)
                {
                    if (atStop.attributes == null)
                    {
                        continue;
                    }

                    var stopDbQuery = from s in _dbContext.BusStops where s.ApiId == atStop.attributes.stop_id select s;

                    //select bustrip if not already in collection 
                    BusStop? busStop = stopDbQuery.FirstOrDefault();

                    if (busStop == null)
                    {
                        busStop = new BusStop();
                        _dbContext.BusStops.Add(busStop);
                    }

                    //add bus stop to trip 
                    if (!busStop.BusTrip.Contains(busTrip))
                    {
                        busStop.BusTrip.Add(busTrip);
                    }
                    
                    if (!busTrip.Stops.Contains(busStop))
                    {
                        busTrip.Stops.Add(busStop);
                    }
                }

                //fetch live location and write to lat long 
                

                //add trip to route
                if (!busRoute.Trips.Contains(busTrip))
                {
                    busRoute.Trips.Add(busTrip);
                }
            }
            //for each trip update stops 
            await _dbContext.SaveChangesAsync();
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
                var query = from r in _dbContext.BusRoutes where r.RouteId == busRoute.RouteId select r;

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
            public string? route_type {get; set;}
        }

        private class Trip
        {
            public string route_id {get; set;}
            public string trip_id {get; set;}
            public string? trip_headsign {get; set;}
            public string? trip_short_name {get; set;}
            public int? direction_id {get; set;}
            public int? wheelchair_accessible {get; set;}
        }

        private class Stop 
        {
            public float stop_lat {get; set;}

            public float stop_long {get; set;}

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

        

    }
}