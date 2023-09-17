using BusMEAPI;
using BusMEAPI.Database;
using Npgsql;
using Quartz;

var builder = WebApplication.CreateBuilder(args);

// Add services to the container.
builder.Services.AddQuartz(q =>{
    q.UseMicrosoftDependencyInjectionJobFactory();

    var jobKey = new JobKey("ApiUpdateJob");
    var jobKey2 = new JobKey("ApiLiveJob");

    q.AddJob<ApiUpdateJob>(ops => ops.WithIdentity(jobKey));
    q.AddJob<ApiLiveUpdate>(ops => ops.WithIdentity(jobKey2));

    q.AddTrigger(opts => opts.ForJob(jobKey).WithIdentity("ApiUpdateJob-trigger").WithCronSchedule("0 0/1 * ? * * *"));
    q.AddTrigger(opts => opts.ForJob(jobKey2).WithIdentity("ApiLiveJob-trigger").WithCronSchedule("30 * * ? * * *"));
    //30 * * ? * * *
    
});

builder.Services.AddQuartzHostedService(q => q.WaitForJobsToComplete = true);

builder.Services.AddControllers();
// Learn more about configuring Swagger/OpenAPI at https://aka.ms/aspnetcore/swashbuckle
builder.Services.AddEndpointsApiExplorer();
builder.Services.AddSwaggerGen();
builder.Services.AddDbContext<BusMEContext>();
builder.Services.AddScoped<UserController, DBUserController>();
builder.Services.AddScoped<BaseAPIIntergration, AtAPIIntergration>();
var app = builder.Build();

// Configure the HTTP request pipeline.
if (app.Environment.IsDevelopment())
{
    app.UseSwagger();
    app.UseSwaggerUI();
}

app.UseHttpsRedirection();

app.UseAuthorization();

app.MapControllers();


app.Run();
