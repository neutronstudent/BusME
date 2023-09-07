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

        private readonly string _audience;
        private readonly string _issuer;
        public JwtAuthService(BusMEContext dbContext, IConfiguration configuration)
        {
            _context = dbContext;
            _config = configuration;
            _audience = configuration["Jwt:Audience"];
            _issuer = configuration["Jwt:Issuer"];
        }

        public override async Task<SecurityToken?> LoginUser(Login login)
        {
            //query database for user
            var query = from u in _context.Users where u.Username == login.Username select u;

            User? user = await query.SingleOrDefaultAsync();

            if (user == null)
                return null;
            
            //check hash with salt
            string hashed = encoding.GetString(hash(login.Password, user.Salt));

            
            //ensure that both are the same
            if (!encoding.GetBytes(hashed).SequenceEqual(encoding.GetBytes(user.Hash)))
                return null;
            
            //since both are the same then generate auth token

            //add secity claims depeding on user type 
            List<Claim> claims = new List<Claim>();

            claims.Add(new Claim(ClaimTypes.Actor, user.Id.ToString()));
            
            //add claim to admin users 
            if (user.Type == User.UserType.Admin)
            {
                claims.Add(new Claim(ClaimTypes.Role, "user"));
            }
            else
            {
                claims.Add(new Claim(ClaimTypes.Role, "admin"));
            }
            
            

            //load requiered cryto stuff 
            SymmetricSecurityKey key = new SymmetricSecurityKey(encoding.GetBytes(_config["Jwt:Key"]));
            SigningCredentials creds = new SigningCredentials(key, SecurityAlgorithms.HmacSha512Signature);

            //describe token
            SecurityTokenDescriptor descriptor = new SecurityTokenDescriptor
            {
                Subject = new ClaimsIdentity(claims),
                Expires = DateTime.Now.AddDays(7),
                SigningCredentials = creds,
                Audience = _audience,
                Issuer = _issuer
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