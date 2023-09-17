
using BusMEAPI;
using Quartz;


[DisallowConcurrentExecution]
public class ApiLiveUpdate : IJob
{  
    private readonly ILogger<ApiUpdateJob> _logger;

    private readonly BaseAPIIntergration _api; 

    public ApiLiveUpdate(ILogger<ApiUpdateJob> logger, BaseAPIIntergration baseAPI)
    {
        _logger = logger;
        _api = baseAPI;
    }

    public async Task Execute(IJobExecutionContext context)
    {
        //update routes and then update results 
        _logger.LogInformation("update live positions");
        int result = await _api.UpdateLive();
        if (result > 0)
        {
            _logger.LogWarning("Unable to update api positions");
        }
        else 
        {
            _logger.LogInformation("Updated posiiotn infomation");
        }
    }
}