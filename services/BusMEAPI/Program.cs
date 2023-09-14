using BusMEAPI;
using BusMEAPI.Database;
using Npgsql;
using Quartz;

var builder = WebApplication.CreateBuilder(args);

// Add services to the container.
builder.Services.AddQuartz(q =>{
    q.UseMicrosoftDependencyInjectionJobFactory();

    var jobKey = new JobKey("ApiUpdateJob");

    q.AddJob<ApiUpdateJob>(ops => ops.WithIdentity(jobKey));

    q.AddTrigger(opts => opts.ForJob(jobKey).WithIdentity("ApiUpdateJob-trigger").WithCronSchedule(""));
    
});

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
