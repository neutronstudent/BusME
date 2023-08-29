using Dapper;
using Npgsql;

namespace BusMEAPI
{
    public class PgInterface : DbInterface
    {

        private IConfiguration _config;
        //private user class for query responses, can be translated into users

        private NpgsqlConnection _connection;

        //takes in a connection and opens it with the Npgsql server
        public PgInterface(IConfiguration configuration)
        {
            _config = configuration;
            this._connection = new NpgsqlConnection(_config.GetConnectionString("PosgresConnection"));

        }

        //opens a connection
        public void Open()
        {
            _connection.Open();
        }

        public override async Task<int> DeleteUser(int id)
        {
            //await on query and delete user using asyncronius methods 
            var parameters = new {TargetId = id};
            String sql = "DELETE FROM users WHERE Id = @TargetId";
            
            //response 
            return await _connection.ExecuteAsync(sql, parameters);

        }

        async public override Task<User> GetUser(int id)
        {
            //create new object with parameter infomation
            var parameters = new {TargetId = id};
            //define sql query
            string sql = "SELECT * FROM users WHERE Id=@TargetId";
            
            //execute async (non blocking query )
            return (await _connection.QueryAsync<User>(sql, parameters)).First();
        }

        //same as above but with username
        async public override Task<User> GetUser(string username)
        {
            var parameters = new {TargetUsername = username};
            string sql = "SELECT * FROM users WHERE Id=@TargetUsername";
            

            return (await _connection.QueryAsync<User>(sql, parameters)).First();
        }

        async public override Task<int> InsertUser(User user)
        {
            //paramaters is a user object
            var parameters = user;
            //insert user object field 
            string sql = "INSERT INTO users (Username, PName, UserType, Email, Phone) VALUES (@Username, @Name, @Type, @Email, @Phone)";
            

            return await _connection.ExecuteAsync(sql, parameters);
        }

        //attempt to mach IDs 
        async public override Task<int> UpdateUser(User user)
        {
            //load parameters as user
            var parameters = user;
            //sql parameter string accesses user vars
            string sql = "UPDATE users SET Username=@Username, PName=@Name, UserType=@Type, Email=@Email, Phone=@Phone) WHERE Id=@Id";
            
            //return sql status code
            return await _connection.ExecuteAsync(sql, parameters);
        }

        //closes a connection
        public void Close()
        {
            _connection.Close();
        }
    }
}