
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
        
        int result = await _api.UpdateRoutes();
        
        if (result > 0 )
        {
            _logger.LogWarning("Unable to update api routes");
        }
        else 
        {
            _logger.LogInformation("Updated route infomation");
        }
    }
}