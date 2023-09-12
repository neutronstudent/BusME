using BusMEAPI.Database;
using System.Net.Http.Headers;
namespace BusMEAPI
{
    public class AtAPIIntergration : BaseAPIIntergration
    {
        private string _apiKey;
        private BusMEContext _dbContext;

        public AtAPIIntergration(BusMEContext dbContext, IConfiguration configuration)
        {
            _apiKey = configuration["api:key"];
            _dbContext = dbContext;

        }

        //GET https://api.at.govt.nz/gtfs/v3/routes/{id}/trips
        //GET https://api.at.govt.nz/gtfs/v3/trips/{id}/stops
        public override async Task<int> UpdateTrips(BusRoute route)
        {


            throw new NotImplementedException();
        }

        public override async Task<int> UpdateRoutes()
        {
            //get routes from at api 
            string api_route = "https://api.at.govt.nz/gtfs/v3/routes";

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

                
            }

            


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
            public string? route_id {get; set;}
            public string? route_short_name {get; set;}
            public string? route_long_name {get; set;}
            public string? route_desc {get; set;}
            public string? route_type {get; set;}
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