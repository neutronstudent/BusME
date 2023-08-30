
using BusMEAPI.Database;
using Microsoft.AspNetCore.Mvc;
using Microsoft.IdentityModel.Tokens;

namespace BusMEAPI
{
    public abstract class BaseAuthService
    {
        //returns valid jwt token or null if no token was able to be created
        public abstract Task<SecurityToken>? LoginUser(Login login);
        public abstract void GeneratePasswordInfo(User user, string password);
    }
}