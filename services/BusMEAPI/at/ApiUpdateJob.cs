
using BusMEAPI;
using Quartz;


[DisallowConcurrentExecution]
public class ApiUpdateJob : IJob
{  
    private readonly ILogger<ApiUpdateJob> _logger;

    private readonly BaseAPIIntergration _api; 

    public ApiUpdateJob(ILogger<ApiUpdateJob> logger, BaseAPIIntergration baseAPI)
    {
        _logger = logger;
        _api = baseAPI;
    }

    public async Task Execute(IJobExecutionContext context)
    {
        //update routes and then update results 
        _logger.LogInformation("Updating Routes");
        int result = await _api.UpdateRoutes();
        _logger.LogInformation("Updating trips");
        int result2 = await _api.UpdateTrips();
        if (result > 0 || result2 > 0)
        {
            _logger.LogWarning("Unable to update api routes/trips");
        }
        else 
        {
            _logger.LogInformation("Updated route infomation");
        }
    }
}