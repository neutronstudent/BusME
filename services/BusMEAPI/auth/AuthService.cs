using BusMEAPI.Database;
using Microsoft.IdentityModel.Tokens;
using Microsoft.EntityFrameworkCore;
using System.Security.Cryptography;
using System.Text;
using System.IdentityModel.Tokens.Jwt;
using System.Security.Claims;

namespace BusMEAPI
{
    public class JwtAuthService : BaseAuthService
    {
        const int HASH_ITERS = 3;
        const int KEY_SIZE = 64;

        private readonly Encoding encoding = Encoding.UTF8;
        private readonly BusMEContext _context;
        private readonly IConfiguration _config;
        public JwtAuthService(BusMEContext dbContext, IConfiguration configuration)
        {
            _context = dbContext;
            _config = configuration;
        }

        public override async Task<SecurityToken?> LoginUser(Login login)
        {
            //query database for user
            var query = from u in _context.Users where u.Username == login.Username select u;

            User? user = await query.SingleOrDefaultAsync();

            if (user == null)
                return null;
            
            //check hash with salt
            byte[] hashed = hash(login.Password, user.Salt);
            
            //ensure that both are the same
            if (!hashed.SequenceEqual(Encoding.UTF8.GetBytes(user.Hash)))
                return null;
            
            //since both are the same then generate auth token
            

            //add secity claims depeding on user type 
            List<Claim> claims = new List<Claim>();

            //add claim to current user to self 
            claims.Add(new Claim("id", user.Id.ToString()));
            claims.Add(new Claim("user", user.Id.ToString()));
            
            //add claim to admin users 
            if (user.Type == User.UserType.Admin)
            {
                claims.Add(new Claim("administrator", user.Id.ToString()));
            }
            

            //load requiered cryto stuff 
            SymmetricSecurityKey key = new SymmetricSecurityKey(encoding.GetBytes(_config["Jwt:Key"]));
            SigningCredentials creds = new SigningCredentials(key, SecurityAlgorithms.HmacSha512Signature);

            //describe token
            SecurityTokenDescriptor descriptor = new SecurityTokenDescriptor
            {
                Subject = new ClaimsIdentity(claims),
                Expires = DateTime.Now.AddDays(7),
                SigningCredentials = creds
                
            };

            SecurityToken token = new JwtSecurityTokenHandler().CreateToken(descriptor);

            //create secuirty token
            return token;
        }

        private byte[] hash(string password, string salt)
        {
            return Rfc2898DeriveBytes.Pbkdf2(encoding.GetBytes(password), encoding.GetBytes(salt), 3, HashAlgorithmName.SHA512, KEY_SIZE);
        }
        
        public override void GeneratePasswordInfo(User user, string password)
        {
            byte[] salt = RandomNumberGenerator.GetBytes(KEY_SIZE);

            user.Salt = encoding.GetString(salt);

            byte[] hashed = hash(password, user.Salt);

            user.Hash = encoding.GetString(hashed);
        }

    }
}