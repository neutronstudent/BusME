using BusMEAPI.Database;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;

namespace BusMEAPI
{
    [ApiController]
    [Route("api/routes")]
    //[Authorize(policy:"UserOnly")]
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

            //return the list 
            return new JsonResult(await _api.GetRoutes());
        }

        //get route by route id
                //get routes
        [HttpGet]
        [Route("{route}")]
        public async Task<ActionResult> GetRoute(int route)
        {

            //execute query 
            BusRoute? result = await _api.GetRoute(route);

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

        public async Task<ActionResult> GetTrips(int route)
        {
            //send route info to user
            //execute query 
            BusRoute? result = await _api.GetRoute(route);

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

        [HttpGet]
        [Route("/api/trips/{id}")]

        public async Task<ActionResult> GetTrip(int id)
        {
            //send route info to user
            //execute query 
            BusTrip? result = await _api.GetTrip(id);

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
            
            return new JsonResult(result);
        }


        [HttpGet]
        [Route("/api/trips/{trip}/stops")]
        public async Task<ActionResult> GetStops(int trip)
        {
            //send route info to user
            //execute query 
            List<BusStop> result = await _api.GetStops(trip);

            //check if query null 

            if (result.Count == 0)
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
            
            return new JsonResult(result);
        }
        
    } 
}