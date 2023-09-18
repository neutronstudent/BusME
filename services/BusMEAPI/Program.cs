using System.Security.Claims;
using System.Text;
using BusMEAPI;
using BusMEAPI.Database;
using Microsoft.AspNetCore.Authentication.JwtBearer;
using Microsoft.Extensions.Options;
using Microsoft.IdentityModel.Tokens;
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

builder.Services.AddHttpContextAccessor();
builder.Services.AddScoped<BaseUserService, DbUserService>();
builder.Services.AddScoped<BaseAuthService, JwtAuthService>();

builder.Services.AddAuthentication(options =>
    {
        options.DefaultAuthenticateScheme = JwtBearerDefaults.AuthenticationScheme;
        options.DefaultChallengeScheme = JwtBearerDefaults.AuthenticationScheme;
        options.DefaultScheme = JwtBearerDefaults.AuthenticationScheme;  
    }).AddJwtBearer(o =>
    {
        o.TokenValidationParameters = new TokenValidationParameters()
        {
            ValidIssuer = builder.Configuration["Jwt:Issuer"],
            ValidAudience = builder.Configuration["Jwt:Audience"],
            IssuerSigningKey = new SymmetricSecurityKey
            (Encoding.UTF8.GetBytes(builder.Configuration["Jwt:Key"])),
            ValidateIssuer = true,
            ValidateAudience = true,
            ValidateLifetime = true,
            ClockSkew = TimeSpan.FromMinutes(30)
            
        };
    });

builder.Services.AddAuthorization(o => 
{
    o.AddPolicy("AdminOnly", policy => policy.RequireClaim(ClaimTypes.Role, new string[] {"admin"}));
    o.AddPolicy("UserOnly", policy => policy.RequireClaim(ClaimTypes.Role, new string[] {"user", "admin"}));
}
);
  
builder.Services.AddScoped<UserController, DBUserController>();
builder.Services.AddScoped<BaseAPIIntergration, AtAPIIntergration>();
var app = builder.Build();




builder.Services.AddSwaggerGen();


var app = builder.Build();

app.UseRouting();
app.UseSwagger();
app.UseSwaggerUI();




app.UseAuthentication();


app.UseHttpsRedirection();

app.UseAuthorization();

app.MapControllers();


app.Run();
