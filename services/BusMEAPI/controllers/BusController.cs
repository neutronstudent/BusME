using BusMEAPI.Database;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;

namespace BusMEAPI
{
    [ApiController]
    [Route("routes")]
    public class BusController : ControllerBase 
    {
        private BusMEContext _db;
        private BaseAPIIntergration _api;
        public BusController(BusMEContext dbContext, BaseAPIIntergration busApi)
        {
            _db = dbContext;
            _api = busApi;
        }

        
        //get routes
        [HttpGet]
        public async Task<ActionResult> GetRoutes()
        {
            //dump all route names stored in database 
            var query =  from r in _db.BusRoutes select new {r.Id, r.RouteLongName, r.RouteShortName};

            //return the list 
            return new JsonResult(await query.ToListAsync());
        }

        //get route by route id
                //get routes
        [HttpGet]
        [Route("{route}")]
        public async Task<ActionResult> GetRoute(int route)
        {
            //send route info to user
            var query = from r in _db.BusRoutes where r.Id.Equals(route) select r;

            //execute query 
            BusRoute? result = await query.SingleOrDefaultAsync();

            //check if query null 
            if (result == null)
            {
                return new NotFoundResult();
            }
            
            //else return route 
            return new JsonResult(result);
        }

        [HttpGet]
        [Route("{route}/trips")]

        public async Task<ActionResult> GetLive(int route)
        {
            //send route info to user
            var query = from r in _db.BusRoutes.Include("Trips") where r.Id.Equals(route) select r;
            //execute query 
            BusRoute? result = await query.SingleOrDefaultAsync();

            //check if query null 

            if (result == null)
            {
                return new NotFoundResult();
            }
            
            //unneeded
            /*
            //check if trips have rencently updatted if not force update
            if (result.LastUpdated.AddSeconds(30) < DateTime.UtcNow)
            {
                await _api.UpdateTrips(result.Id);
            

                result = await query.SingleOrDefaultAsync();

                if (result == null)
                {
                    return new NotFoundResult();
                }
            }
            */
            
            return new JsonResult(result.Trips);
        }
        
    } 
}